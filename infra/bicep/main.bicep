// AdsRunner Infrastructure — Main Orchestrator
// Deploys all Azure resources for the AdsRunner platform.
//
// Usage:
//   az deployment group create \
//     --resource-group rg-adsrunner-dev \
//     --template-file main.bicep \
//     --parameters parameters/dev.bicepparam

targetScope = 'resourceGroup'

@description('Environment name (dev, staging, prod)')
param environment string

@description('Azure region for resources')
param location string = resourceGroup().location

@description('SQL Server administrator login')
@secure()
param sqlAdminLogin string

@description('SQL Server administrator password')
@secure()
param sqlAdminPassword string

// --- Modules ---

module sql 'modules/sql.bicep' = {
  name: 'sql-${environment}'
  params: {
    environment: environment
    location: location
    adminLogin: sqlAdminLogin
    adminPassword: sqlAdminPassword
  }
}

module appService 'modules/app-service.bicep' = {
  name: 'app-service-${environment}'
  params: {
    environment: environment
    location: location
    sqlConnectionString: sql.outputs.connectionString
  }
}

module storage 'modules/storage.bicep' = {
  name: 'storage-${environment}'
  params: {
    environment: environment
    location: location
  }
}

module keyVault 'modules/key-vault.bicep' = {
  name: 'key-vault-${environment}'
  params: {
    environment: environment
    location: location
  }
}
