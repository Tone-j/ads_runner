// Azure Key Vault Module
// Provisions Key Vault for secrets management.

param environment string
param location string

var vaultName = 'kv-adsrunner-${environment}'

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: vaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enableRbacAuthorization: true
  }
}

output vaultUri string = keyVault.properties.vaultUri
