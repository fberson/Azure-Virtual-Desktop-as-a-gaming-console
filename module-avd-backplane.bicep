//Define AVD deployment parameters
param hostpoolName string
param hostpoolFriendlyName string
param appgroupName string
param appgroupDesktopFriendlyName string
param workspaceName string
param workspaceNameFriendlyName string
param preferredAppGroupType string = 'Desktop'
param AVDbackplanelocation string = 'eastus'
param hostPoolType string = 'pooled'
param loadBalancerType string = 'BreadthFirst'
param enableValiatioMode bool
param expirationTime string = utcNow('u')
param startVMOnConnect bool = true

var customRDPProperties = 'audiocapturemode:i:1;audiomode:i:0;camerastoredirect:s:*;devicestoredirect:s:*;videoplaybackmode:i:1;usbdevicestoredirect:s:*'

//Create AVD Hostpool
resource hp 'Microsoft.DesktopVirtualization/hostPools@2021-03-09-preview' = {
  name: hostpoolName
  location: AVDbackplanelocation
  properties: {
    friendlyName: hostpoolFriendlyName
    hostPoolType: hostPoolType
    loadBalancerType: loadBalancerType
    preferredAppGroupType: preferredAppGroupType
    validationEnvironment: enableValiatioMode
    registrationInfo: {
      expirationTime: dateTimeAdd(expirationTime, 'PT2H')
      registrationTokenOperation: 'Update'
    }
    startVMOnConnect: startVMOnConnect
    customRdpProperty: customRDPProperties
  }
}

//Create AVD Desktop AppGroup
resource agd 'Microsoft.DesktopVirtualization/applicationGroups@2021-03-09-preview' = {
  name: appgroupName
  location: AVDbackplanelocation
  properties: {
    friendlyName: appgroupDesktopFriendlyName
    applicationGroupType: 'Desktop'
    hostPoolArmPath: hp.id
  }
}

//Create AVD Workspace in case createRemoteAppHostpool = false
resource ws 'Microsoft.DesktopVirtualization/workspaces@2021-03-09-preview' = {
  name: workspaceName
  location: AVDbackplanelocation
  properties: {
    friendlyName: workspaceNameFriendlyName
    applicationGroupReferences: [
      agd.id
    ]
  }
}

//Output the generated host pool registration token
output hpkey string = hp.properties.registrationInfo.token
