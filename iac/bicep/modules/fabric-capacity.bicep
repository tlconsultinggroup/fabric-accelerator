// Parameters
@description('The name of the Fabric Capacity.')
param fabric_name string

@description('The Azure Region to deploy the resources into.')
param location string = resourceGroup().location

@description('Cost Centre tag that will be applied to all resources in this deployment')
param cost_centre_tag string

@description('System Owner tag that will be applied to all resources in this deployment')
param owner_tag string

@description('Subject Matter Expert (SME) tag that will be applied to all resources in this deployment')
param sme_tag string

@description('The SKU name of the Fabric Capacity.')
@allowed([
  'F2'
  'F4'
  'F8'
  'F16'
  'F32'
  'F64'
  'F128'
  'F256'
  'F512'
  'F1024'
  'F2048'
])
param skuName string = 'F2'

@description('The SKU tier of the Fabric Capacity instance.')
param skuTier string = 'Fabric'

@description('The list of administrators for the Fabric Capacity instance.')
@secure()
param adminUsers string


// Variables
var suffix = uniqueString(resourceGroup().id)
var fabric_uniquename = '${fabric_name}${suffix}'

// Resource: Microsoft Fabric Capacity
resource fabricCapacity 'Microsoft.Fabric/capacities@2023-11-01' = {
  name: toLower(fabric_uniquename)
  location: location
  tags: {
    CostCentre: cost_centre_tag
    Owner: owner_tag
    SME: sme_tag
  }
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    administration: {
      members: [adminUsers]
    }
  }
}

// Outputs
@description('The ID of the Fabric Capacity.')
output resourceId string = fabricCapacity.id

@description('The name of the Fabric Capacity.')
output resourceName string = fabricCapacity.name
