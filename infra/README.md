# Infrastructure as Code (IaC)

This directory contains Azure Bicep templates for provisioning AdsRunner cloud resources.

## Structure

```
infra/
├── bicep/
│   ├── main.bicep              # Orchestrator — deploys all modules
│   ├── modules/
│   │   ├── sql.bicep           # Azure SQL Database
│   │   ├── app-service.bicep   # App Service for API
│   │   ├── b2c.bicep           # Azure AD B2C (reference/docs)
│   │   ├── storage.bicep       # Azure Blob Storage
│   │   └── key-vault.bicep     # Azure Key Vault
│   └── parameters/
│       ├── dev.bicepparam      # Development environment
│       ├── staging.bicepparam  # Staging environment
│       └── prod.bicepparam     # Production environment
└── pipelines/
    └── README.md               # CI/CD pipeline strategy
```

## Deployment

```bash
# Deploy to development
az deployment group create \
  --resource-group rg-adsrunner-dev \
  --template-file bicep/main.bicep \
  --parameters bicep/parameters/dev.bicepparam

# Deploy to staging
az deployment group create \
  --resource-group rg-adsrunner-staging \
  --template-file bicep/main.bicep \
  --parameters bicep/parameters/staging.bicepparam
```

## Prerequisites

- Azure CLI installed and authenticated
- Contributor access on target resource group
- Azure AD B2C tenant provisioned separately (see b2c.bicep for docs)
