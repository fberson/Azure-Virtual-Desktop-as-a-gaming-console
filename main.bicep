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

// Scaling plan & schedule parameters
param scalingPlanDescription string = 'Demo scaling plan'
param scalingPlanExclusionTag string = 'ExcludeTag'
param scalingPlanFriendlyName string = 'This is a demo scaling plan'
@allowed([
  'Pooled'
])
param scalingPlanHostPoolType string = 'Pooled'
param scalingPlanLocation string = 'westeurope'
param scalingPlanName string = 'BicepDemoScalingPlan'
param scalingPlanTimeZone string = 'W. Europe Standard Time'
param weekdaysScheduleName string = 'Demo weekdays'
@allowed([
  'BreadthFirst'
  'DepthFirst'
])
param weekdaysSchedulepeakLoadBalancingAlgorithm string = 'BreadthFirst'
param weekdaysSchedulepeakStartTimeHour int = 9
param weekdaysSchedulepeakStartTimeMinute int = 0
param weekdaysSchedulerampDownCapacityThresholdPct int = 10
param weekdaysSchedulerampDownForceLogoffUsers bool = false
param weekdaysSchedulerampDownMinimumHostsPct int = 10
param weekdaysSchedulerampDownStartTimeHour int = 18
param weekdaysSchedulerampDownStartTimeMinute int = 0
@allowed([
  'ZeroSessions'
  'ZeroActiveSessions'
])
param weekdaysSchedulerampDownStopHostsWhen string = 'ZeroSessions'
param weekdaysSchedulerampUpCapacityThresholdPct int = 60
@allowed([
  'BreadthFirst'
  'DepthFirst'
])
param weekdaysSchedulerampUpLoadBalancingAlgorithm string = 'DepthFirst'
param weekdaysSchedulerampUpMinimumHostsPct int = 20
param weekdaysSchedulerampUpStartTimeHour int = 8
param weekdaysSchedulerampUpStartTimeMinute int = 0
param weekdaysScheduleoffPeakStartTimeHour int = 20
param weekdaysScheduleoffPeakStartTimeMinute int = 0
@allowed([
  'BreadthFirst'
  'DepthFirst'
])
param weekdaysSchedulerampDownLoadBalancingAlgorithm string = 'DepthFirst'
param weekdaysrampDownWaitTimeMinutes int = 30
param weekdaysrampDownNotificationMessage string = 'You will be logged off in 30 min. Make sure to save your work.'
param weekendsScheduleName string = 'Demo weekends'
@allowed([
  'BreadthFirst'
  'DepthFirst'
])
param weekendsSchedulepeakLoadBalancingAlgorithm string = 'BreadthFirst'
param weekendsSchedulepeakStartTimeHour int = 9
param weekendsSchedulepeakStartTimeMinute int = 0
param weekendsSchedulerampDownCapacityThresholdPct int = 10
param weekendsSchedulerampDownForceLogoffUsers bool = false
param weekendsSchedulerampDownMinimumHostsPct int = 10
param weekendsSchedulerampDownStartTimeHour int = 18
param weekendsSchedulerampDownStartTimeMinute int = 0
@allowed([
  'ZeroSessions'
  'ZeroActiveSessions'
])
param weekendsSchedulerampDownStopHostsWhen string = 'ZeroSessions'
param weekendsSchedulerampUpCapacityThresholdPct int = 60
@allowed([
  'BreadthFirst'
  'DepthFirst'
])
param weekendsSchedulerampUpLoadBalancingAlgorithm string = 'DepthFirst'
param weekendsSchedulerampUpMinimumHostsPct int = 20
param weekendsSchedulerampUpStartTimeHour int = 8
param weekendsSchedulerampUpStartTimeMinute int = 0
param weekendsScheduleoffPeakStartTimeHour int = 20
param weekendsScheduleoffPeakStartTimeMinute int = 0
@allowed([
  'BreadthFirst'
  'DepthFirst'
])
param weekendsSchedulerampDownLoadBalancingAlgorithm string = 'DepthFirst'
param weekendsrampDownWaitTimeMinutes int = 30
param weekendsrampDownNotificationMessage string = 'You will be logged off in 30 min. Make sure to save your work.'

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

//Concat the PoolArmPath required by the scalingplan
var scalingPlanhostPoolArmPath = '${subscription().id}/resourcegroups/${rgAVD.name}/providers/Microsoft.DesktopVirtualization/hostpools/${hostpoolName}'

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
resource rdScaling 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupPrefix}SCALING${resourceGroupPostfix}'
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

module AVDScaling 'br/CoreModules:module-avd-scaling-plan:v1' = {
  scope: rdScaling
  name: 'rdScaling'
  params: {
    scalingPlanDescription: scalingPlanDescription
    scalingPlanExclusionTag: scalingPlanExclusionTag
    scalingPlanFriendlyName: scalingPlanFriendlyName
    scalingPlanHostPoolType: scalingPlanHostPoolType
    scalingPlanLocation: scalingPlanLocation
    scalingPlanName: scalingPlanName
    scalingPlanTimeZone: scalingPlanTimeZone
    scalingPlanhostPoolArmPath: scalingPlanhostPoolArmPath
    scalingPlanEnabled: true
    weekdaysrampDownNotificationMessage: weekdaysrampDownNotificationMessage
    weekdaysrampDownWaitTimeMinutes: weekdaysrampDownWaitTimeMinutes
    weekdaysScheduleName: weekdaysScheduleName
    weekdaysScheduleoffPeakStartTimeHour: weekdaysScheduleoffPeakStartTimeHour
    weekdaysScheduleoffPeakStartTimeMinute: weekdaysScheduleoffPeakStartTimeMinute
    weekdaysSchedulepeakLoadBalancingAlgorithm: weekdaysSchedulepeakLoadBalancingAlgorithm
    weekdaysSchedulepeakStartTimeHour: weekdaysSchedulepeakStartTimeHour
    weekdaysSchedulepeakStartTimeMinute: weekdaysSchedulepeakStartTimeMinute
    weekdaysSchedulerampDownCapacityThresholdPct: weekdaysSchedulerampDownCapacityThresholdPct
    weekdaysSchedulerampDownForceLogoffUsers: weekdaysSchedulerampDownForceLogoffUsers
    weekdaysSchedulerampDownLoadBalancingAlgorithm: weekdaysSchedulerampDownLoadBalancingAlgorithm
    weekdaysSchedulerampDownMinimumHostsPct: weekdaysSchedulerampDownMinimumHostsPct
    weekdaysSchedulerampDownStartTimeHour: weekdaysSchedulerampDownStartTimeHour
    weekdaysSchedulerampDownStartTimeMinute: weekdaysSchedulerampDownStartTimeMinute
    weekdaysSchedulerampDownStopHostsWhen: weekdaysSchedulerampDownStopHostsWhen
    weekdaysSchedulerampUpCapacityThresholdPct: weekdaysSchedulerampUpCapacityThresholdPct
    weekdaysSchedulerampUpLoadBalancingAlgorithm: weekdaysSchedulerampUpLoadBalancingAlgorithm
    weekdaysSchedulerampUpMinimumHostsPct: weekdaysSchedulerampUpMinimumHostsPct
    weekdaysSchedulerampUpStartTimeHour: weekdaysSchedulerampUpStartTimeHour
    weekdaysSchedulerampUpStartTimeMinute: weekdaysSchedulerampUpStartTimeMinute
    weekendsrampDownNotificationMessage: weekendsrampDownNotificationMessage
    weekendsrampDownWaitTimeMinutes: weekendsrampDownWaitTimeMinutes
    weekendsScheduleName: weekendsScheduleName
    weekendsScheduleoffPeakStartTimeHour: weekendsScheduleoffPeakStartTimeHour
    weekendsScheduleoffPeakStartTimeMinute: weekendsScheduleoffPeakStartTimeMinute
    weekendsSchedulepeakLoadBalancingAlgorithm: weekendsSchedulepeakLoadBalancingAlgorithm
    weekendsSchedulepeakStartTimeHour: weekendsSchedulepeakStartTimeHour
    weekendsSchedulepeakStartTimeMinute: weekendsSchedulepeakStartTimeMinute
    weekendsSchedulerampDownCapacityThresholdPct: weekendsSchedulerampDownCapacityThresholdPct
    weekendsSchedulerampDownForceLogoffUsers: weekendsSchedulerampDownForceLogoffUsers
    weekendsSchedulerampDownLoadBalancingAlgorithm: weekendsSchedulerampDownLoadBalancingAlgorithm
    weekendsSchedulerampDownMinimumHostsPct: weekendsSchedulerampDownMinimumHostsPct
    weekendsSchedulerampDownStartTimeHour: weekendsSchedulerampDownStartTimeHour
    weekendsSchedulerampDownStartTimeMinute: weekendsSchedulerampDownStartTimeMinute
    weekendsSchedulerampDownStopHostsWhen: weekendsSchedulerampDownStopHostsWhen
    weekendsSchedulerampUpCapacityThresholdPct: weekendsSchedulerampUpCapacityThresholdPct
    weekendsSchedulerampUpLoadBalancingAlgorithm: weekendsSchedulerampUpLoadBalancingAlgorithm
    weekendsSchedulerampUpMinimumHostsPct: weekendsSchedulerampUpMinimumHostsPct
    weekendsSchedulerampUpStartTimeHour: weekendsSchedulerampUpStartTimeHour
    weekendsSchedulerampUpStartTimeMinute: weekendsSchedulerampUpStartTimeMinute
  }
  dependsOn: [
    AVDbackplaneprod
  ]
}
