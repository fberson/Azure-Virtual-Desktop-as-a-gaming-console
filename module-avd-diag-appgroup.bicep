//Define diagnostic setting  parameters
param appGroupName string
param logAnalyticslocation string = 'westeurope'
param logAnalyticsWorkspaceID string

//Concat diagnostic setting names
var workspaceDiagName = '${appGroupName}/Microsoft.Insights/hostpool-diag'

//Create diagnostic settings for WVD Objects
resource wvdwsds 'Microsoft.DesktopVirtualization/ApplicationGroups/providers/diagnosticSettings@2017-05-01-preview' = {
  name: workspaceDiagName
  location: logAnalyticslocation
  properties: {
    workspaceId: logAnalyticsWorkspaceID
    logs: [
      {
        category: 'Checkpoint'
        enabled: 'True'
      }
      {
        category: 'Error'
        enabled: 'True'
      }
      {
        category: 'Management'
        enabled: 'True'
      }
    ]
  }
}
