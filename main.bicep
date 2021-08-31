targetScope = 'subscription'

//Define AVD deployment parameters
param resourceGroupPrefix string
param resourceGroupPostfix string
param AVDbackplanelocation string
param hostPoolType string = 'pooled'
param loadBalancerType string = 'BreadthFirst'
param hostpoolFriendlyName string = 'Hostpool with AVD Gaming Desktop'
param appgroupDesktopFriendlyName string = 'AppGroup with AVD Gaming Desktop'
param workspaceFriendlyName string = 'AVD Gaming Demo'
param hostpoolName string
param appgroupName string
param workspaceName string
param preferredAppGroupType string = 'Desktop'

//define log analytics parameters
param logAnalyticsWorkspaceName string
param logAnalyticsWorkspaceSku string = 'pergb2018'

//Define Networking deployment parameters
param vnetName string
param vnetaddressPrefix string
param subnetPrefix string
param subnetName string
param dnsServer string

//define peering parameters
param createPeering bool = true
param remoteVnetName string
param remoteVnetRg string

//define session host parameters
param vmNameprefix string = 'AVD-Gaming'
@allowed([
  'Nvidia'
  'AMD'
])
param gpuType string = 'Nvidia'
param vmSize string = 'Standard_NV6'
param avSetName string
param ouLocationWVDSessionHost string
param domainJoinUSer string
@secure()
param secretValueDomainJoin string
param adDomainName string
@secure()
param secretValueLocalAdminPassword string

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

//Create AVD Prod backplane objects and configure Log Analytics Diagnostics Settings
module AVDbackplaneprod './module-avd-backplane.bicep' = [for AVDbackplane in AVDbackplanes: {
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

//Create AVD Netwerk, Subnet and template image VM
module AVDnetwork './module-avd-network.bicep' = {
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

//Create Azure Log Analytics Workspace
module AVDla './module-avdlog-analytics.bicep' = {
  name: 'AVDla'
  scope: rgmon
  params: {
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    logAnalyticslocation: rgmon.location
    logAnalyticsWorkspaceSku: logAnalyticsWorkspaceSku
  }
}

//Create the AVD Session Host with GPU support
module AVDSessionHost 'module-avd-sessionhost.bicep' = {
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
}
