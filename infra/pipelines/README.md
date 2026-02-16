# CI/CD Pipelines

## Strategy

AdsRunner uses GitHub Actions for CI/CD:

1. **Flutter Client** — Build, analyze, deploy to GitHub Pages (existing)
2. **API Backend** — Build, test, deploy to Azure App Service (Phase 2)
3. **Infrastructure** — Bicep deployment to Azure (Phase 2)
4. **Liquibase** — Schema migration as part of deploy pipeline (Phase 2)

## Pipeline Files

| Pipeline | File | Trigger |
|----------|------|---------|
| Flutter Deploy | `.github/workflows/deploy.yml` | Push to `main` |
| API CI | `.github/workflows/api-ci.yml` | PR to `main` (Phase 2) |
| API Deploy | `.github/workflows/api-deploy.yml` | Push to `main` (Phase 2) |
| Infra Deploy | `.github/workflows/infra-deploy.yml` | Manual (Phase 2) |

## Liquibase in CI

Liquibase will run as a step in the API deploy pipeline:

```yaml
- name: Run Liquibase Migrations
  run: |
    cd sql
    liquibase \
      --url=${{ secrets.SQL_CONNECTION_URL }} \
      --username=${{ secrets.SQL_USERNAME }} \
      --password=${{ secrets.SQL_PASSWORD }} \
      --changeLogFile=synap-changelog-master.xml \
      update
```
