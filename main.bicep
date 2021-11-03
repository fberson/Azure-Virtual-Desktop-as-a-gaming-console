targetScope = 'subscription'

//Define AVD deployment parameters
param resourceGroupPrefix string = 'BICEP-AVD-GAMING-DEMO-'
param resourceGroupPostfix string = '-RG'
param AVDbackplanelocation string = 'westeurope'
param hostPoolType string = 'pooled'
param loadBalancerType string = 'BreadthFirst'
param hostpoolFriendlyName string = 'Hostpool with AVD Gaming Desktop'
param appgroupDesktopFriendlyName string = 'AppGroup with AVD Gaming Desktop'
param workspaceFriendlyName string = 'AVD Gaming Demo'
param hostpoolName string = 'BICEP-AVD-HP-DEMO'
param appgroupName string = 'BICEP-AVD-AG-DEMO'
param workspaceName string = 'BICEP-AVD-WS-DEMO'
param preferredAppGroupType string = 'Desktop'

//define log analytics parameters
param logAnalyticsWorkspaceName string = 'BICEP-AVD-DEMO-3'
param logAnalyticsWorkspaceSku string = 'pergb2018'

//Define Networking deployment parameters
param vnetName string = 'BICEP-AVD-GAMING-VNET'
param vnetaddressPrefix string = '10.80.0.0/16'
param subnetPrefix string = '10.80.10.0/24'
param subnetName string = 'BICEP-AVD-GAMING-SUBNET'
param dnsServer string = '10.50.1.4'

//define peering parameters
param createPeering bool = true
param remoteVnetName string = 'NINJA-WE-P-VNET-10-50-0-0-16'
param remoteVnetRg string = 'NINJA-WE-P-RG-NETWORK'

//define session host parameters
param vmNameprefix string = 'AVD-Gaming'
@allowed([
  'Nvidia'
  'AMD'
])
param gpuType string = 'Nvidia'
param vmSize string = 'Standard_NV6'
param avSetName string = 'avsetdemo'
param ouLocationWVDSessionHost string = 'OU=Bicep-demo,OU=WVD-SpringRelease,OU=Servers,OU=NINJA,DC=wvd,DC=ninja'
param domainJoinUSer string = 'ninja-svc-wvd@wvd.ninja'
@secure()
param secretValueDomainJoin string
param adDomainName string = 'wvd.ninja'
@secure()
param secretValueLocalAdminPassword string

//var logAnalyticsWorkspaceID = '/subscriptions/'
//"/subscriptions/66869840-a086-41d1-84e9-cf66ac8a9a94/resourcegroups/bicep-avd-gaming-demo-monitoring-rg/providers/microsoft.operationalinsights/workspaces/bicep-avd-demo-3"

var AVDbackplanes = [
  {
    hostpoolName: hostpoolName
    hostpoolFriendlyName: hostpoolFriendlyName
    appgroupName: appgroupName
    appgroupDesktopFriendlyName: appgroupDesktopFriendlyName
    workspaceName: workspaceName
    workspaceNameFriendlyName: workspaceFriendlyName
    preferredAppGroupType: preferredAppGroupType
    AVDbackplanelocation: AVDbackplanelocation
    hostPoolType: hostPoolType
    enableValiatioMode: false
    loadBalancerType: loadBalancerType
    createRemoteAppHostpool: true
    startVMOnConnect: true
  }
]

//Create Resource Groups
resource rgnw 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupPrefix}NETWORK${resourceGroupPostfix}'
  location: 'westeurope'
}
resource rgAVD 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupPrefix}BACKPLANE${resourceGroupPostfix}'
  location: 'westeurope'
}
resource rgmon 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupPrefix}MONITORING${resourceGroupPostfix}'
  location: 'westeurope'
}
resource rgAVDhost 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupPrefix}HOSTS${resourceGroupPostfix}'
  location: 'westeurope'
}

@description('Create AVD Prod backplane objects')
module AVDbackplaneprod 'br/CoreModules:module-avd-backplane:v1' = [for AVDbackplane in AVDbackplanes: {
  name: '${AVDbackplane.hostpoolName}-deploy'
  scope: rgAVD
  params: {
    hostpoolName: AVDbackplane.hostpoolName
    hostpoolFriendlyName: AVDbackplane.hostpoolFriendlyName
    appgroupName: AVDbackplane.appgroupName
    appgroupDesktopFriendlyName: AVDbackplane.appgroupDesktopFriendlyName
    workspaceName: AVDbackplane.workspaceName
    workspaceNameFriendlyName: AVDbackplane.workspaceNameFriendlyName
    preferredAppGroupType: AVDbackplane.preferredAppGroupType
    AVDbackplanelocation: AVDbackplane.AVDbackplanelocation
    hostPoolType: AVDbackplane.hostPoolType
    enableValiatioMode: AVDbackplane.enableValiatioMode
    loadBalancerType: AVDbackplane.loadBalancerType
    startVMOnConnect: AVDbackplane.startVMOnConnect
  }
}]

@description('Create AVD NetwertandSubnet')
module AVDnetwork 'br/CoreModules:module-avd-network:v1' = {
  name: 'AVDnetwork'
  scope: rgnw
  params: {
    vnetLocation: rgnw.location
    vnetName: vnetName
    vnetaddressPrefix: vnetaddressPrefix
    dnsServer: dnsServer
    subnet1Prefix: subnetPrefix
    subnet1Name: subnetName
    createPeering: createPeering
    remoteVnetName: remoteVnetName
    remoteVnetRg: remoteVnetRg
    vNetVMResourceGroup: rgnw.name
  }
}

@description('Create Azure Log Analytics Workspace')
module AVDla 'br/CoreModules:module-avdlog-analytics:v1' = {
  name: 'AVDla'
  scope: rgmon
  params: {
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    logAnalyticslocation: rgmon.location
    logAnalyticsWorkspaceSku: logAnalyticsWorkspaceSku
  }
}

@description('Config log analytics for all AVD control plane resources')
module AVDMon 'br/CoreModules:module-avd-monitor:v1' = {
  name: 'AVDMon'
  scope: rgmon
  params: {
    appGroupName: appgroupName
    AVDBackplaneResourceGroup: rgAVD.name
    hostpoolName: hostpoolName
    logAnalyticsWorkspaceID: AVDla.outputs.logAnalyticsWorkspaceResourceID
    workspaceName: workspaceName
  }
}

@description('Create the AVD Session Host with GPU support')
module AVDSessionHost 'br/CoreModules:module-avd-sessionhost:v1' = {
  scope: rgAVDhost
  name: 'AVDSessionHost'
  params: {
    domainJoinPassword: secretValueDomainJoin
    domainJoinUPN: domainJoinUSer
    localAdminPassword: secretValueLocalAdminPassword
    registrationKey: AVDbackplaneprod[0].outputs.hpkey
    virtualMachineSizeWVD: vmSize
    existingVnetName: vnetName
    existingSubnetName: subnetName
    existingVnetResourceGroupName: rgnw.name
    hostNamePrefixWVD: vmNameprefix
    numberOfInstancesWVD: 1
    availabilitySetName: avSetName
    ouLocationWVDSessionHost: ouLocationWVDSessionHost
    adDomainName: adDomainName
    gpuType: gpuType
  }
  dependsOn: [
    AVDbackplaneprod
  ]
}
