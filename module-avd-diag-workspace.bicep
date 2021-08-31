//Define diagnostic setting  parameters
param workspaceName string
param logAnalyticsWorkspaceID string

resource ws 'Microsoft.DesktopVirtualization/hostPools@2021-03-09-preview' existing = {
  name:workspaceName
}

//Create diagnostic settings for AVD Objects
resource AVDwsds 'Microsoft.DesktopVirtualization/workspaces/providers/diagnosticSettings@2017-05-01-preview' = {
  name: '${ws.name}/Microsoft.Insights/workspace-diag'
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
        category: 'Feed'
        enabled: true
      }
    ]
  }
}
