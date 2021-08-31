//Define diagnostic setting  parameters
param logAnalyticsWorkspaceID string
param AVDBackplaneResourceGroup string
param hostpoolName string
param workspaceName string
param appGroupName string

module AVDhostpooldiag 'module-avd-diag-hostpool.bicep' = {
  name: 'AVDhostpooldiag1'
  scope: resourceGroup(AVDBackplaneResourceGroup)
  params: {
    hostpoolName: hostpoolName
    logAnalyticsWorkspaceID: logAnalyticsWorkspaceID
  }
}

module AVDWorkspacediag 'module-avd-diag-workspace.bicep' = {
  name: 'AVDWorkspacediag1'
  scope: resourceGroup(AVDBackplaneResourceGroup)
  params: {
    workspaceName: workspaceName
    logAnalyticsWorkspaceID: logAnalyticsWorkspaceID
  }
}

module AVDAppGroupdiag 'module-avd-diag-appgroup.bicep' = {
  name: 'AVDAppGroupdiag1'
  scope: resourceGroup(AVDBackplaneResourceGroup)
  params: {
    appGroupName: appGroupName
    logAnalyticsWorkspaceID: logAnalyticsWorkspaceID
  }
}
