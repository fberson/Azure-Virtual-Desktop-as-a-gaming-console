// Define Networking parameters
param vnetLocation string
param vnetName string
param vnetaddressPrefix string
param subnet1Prefix string
param subnet1Name string
param dnsServer string

//define peering parameters
param createPeering bool
param remoteVnetRg string
param remoteVnetName string

//define user identity
param vNetVMResourceGroup string

//Create Vnet and Subnet
resource vnet 'Microsoft.Network/virtualnetworks@2020-06-01' = {
  name: vnetName
  location: vnetLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetaddressPrefix
      ]
    }
    dhcpOptions: {
      dnsServers: [
        dnsServer
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1Prefix
        }
      }
    ]
  }
}

//Optionally create vnet peering to an ADDS vnet
resource peertoadds 'microsoft.network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = if (createPeering) {
  name: '${vnet.name}/peering-to-adds-vnet'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId(remoteVnetRg, 'Microsoft.Network/virtualNetworks', remoteVnetName)
    }
  }
}

//Optionally create vnet peering from an ADDS vnet
module peerfromadds './module-avd-vnet-peering.bicep' = if (createPeering) {
  name: 'peering'
  scope: resourceGroup(remoteVnetRg)
  params: {
    remoteVnetName: remoteVnetName
    vnetName: vnet.name
    vnetNameResourceGroup: vNetVMResourceGroup
  }
}
