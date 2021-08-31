//Define diagnostic setting  parameters
param hostpoolName string
param logAnalyticsWorkspaceID string

resource hp 'Microsoft.DesktopVirtualization/hostPools@2021-03-09-preview' existing = {
  name:hostpoolName
}

//Create diagnostic settings for AVD Objects
resource AVDwsds 'Microsoft.DesktopVirtualization/hostpools/providers/diagnosticSettings@2017-05-01-preview' = {
  name: '${hp.name}/Microsoft.Insights/hostpool-diag'
  properties: {
    workspaceId: logAnalyticsWorkspaceID
    logs: [
      {
        category: 'Checkpoint'
        enabled: true
      }
      {
        category: 'Error'
        enabled: true
      }
      {
        category: 'Management'
        enabled: true
      }
      {
        category: 'Connection'
        enabled: true
      }
      {
        category: 'HostRegistration'
        enabled: true
      }
    ]
  }
}
