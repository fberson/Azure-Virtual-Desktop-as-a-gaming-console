//Define diagnostic setting  parameters
param logAnalyticsWorkspaceID string
param AVDBackplaneResourceGroup string
param hostpoolName string
param workspaceName string
param appGroupName string

module AVDhostpooldiag 'br/CoreModules:module-avd-diag-hostpool:v1' = {
  name: 'AVDhostpooldiag1'
  scope: resourceGroup(AVDBackplaneResourceGroup)
  params: {
    hostpoolName: hostpoolName
    logAnalyticsWorkspaceID: logAnalyticsWorkspaceID
  }
}

module AVDWorkspacediag 'br/CoreModules:module-avd-diag-workspace:v1' = {
  name: 'AVDWorkspacediag1'
  scope: resourceGroup(AVDBackplaneResourceGroup)
  params: {
    workspaceName: workspaceName
    logAnalyticsWorkspaceID: logAnalyticsWorkspaceID
  }
}

module AVDAppGroupdiag 'br/CoreModules:module-avd-diag-appgroup:v1' = {
  name: 'AVDAppGroupdiag1'
  scope: resourceGroup(AVDBackplaneResourceGroup)
  params: {
    appGroupName: appGroupName
    logAnalyticsWorkspaceID: logAnalyticsWorkspaceID
  }
}
