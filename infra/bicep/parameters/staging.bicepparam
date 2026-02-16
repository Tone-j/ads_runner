using '../main.bicep'

param environment = 'staging'
param sqlAdminLogin = 'sqladmin'
param sqlAdminPassword = '' // Set via Azure DevOps pipeline variable
