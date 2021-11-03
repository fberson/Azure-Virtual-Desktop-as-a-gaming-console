//Define diagnostic setting  parameters
param appGroupName string
param logAnalyticslocation string = 'westeurope'
param logAnalyticsWorkspaceID string

//Concat diagnostic setting names
var appgroupDiagName = '${appGroupName}/Microsoft.Insights/appgroup-diag'

//Create diagnostic settings for WVD Objects
resource wvdwsds 'Microsoft.DesktopVirtualization/ApplicationGroups/providers/diagnosticSettings@2017-05-01-preview' = {
  name: appgroupDiagName
  location: logAnalyticslocation
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
        enabled: false
      }
    ]
  }
}
