using '../main.bicep'

param environment = 'dev'
param sqlAdminLogin = 'sqladmin'
param sqlAdminPassword = '' // Set via Azure DevOps pipeline variable
