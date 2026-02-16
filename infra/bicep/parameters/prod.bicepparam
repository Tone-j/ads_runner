using '../main.bicep'

param environment = 'prod'
param sqlAdminLogin = 'sqladmin'
param sqlAdminPassword = '' // Set via Azure DevOps pipeline variable
