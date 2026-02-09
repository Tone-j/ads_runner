# AdsRunner - Taxi Billboard Advertising Platform

A cloud-native SaaS platform for managing, scheduling, and analyzing digital billboard advertisements on public transport vehicles (taxis and buses). Built on **C#/.NET**, **Azure**, and **Flutter** for cross-platform reach, enterprise-grade reliability, and real-time analytics.

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [System Components](#system-components)
- [System Workflow](#system-workflow)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Deployment](#deployment)
- [Scalability](#scalability)
- [Security](#security)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

AdsRunner enables businesses to advertise on LCD/LED screens installed in taxis and buses. The platform provides:

- **Ad Targeting** - Target ads by region (urban, semi-urban, rural) and schedule displays at specific times.
- **Client Ad Management** - Upload, create, and manage ad campaigns through a self-service portal.
- **Ad Analytics** - Real-time exposure metrics, passenger count estimates, and campaign performance dashboards.
- **Subscription Services** - Tiered subscription plans with integrated payment processing.
- **Content Delivery** - Secure, low-latency delivery of ad content to vehicle-mounted screens via CDN.
- **Passenger Monitoring** - Camera-equipped smart screens for anonymous passenger counting and reach estimation.

---

## Architecture

AdsRunner follows a **microservices architecture** hosted on **Microsoft Azure**, with clearly separated concerns across backend services, mobile/web clients, and IoT edge devices.

```
                          +-------------------+
                          |   Flutter Clients  |
                          | (Web / iOS / Android)|
                          +---------+---------+
                                    |
                              HTTPS / REST
                                    |
                    +---------------v----------------+
                    |      Azure API Management      |
                    |         (Gateway / WAF)         |
                    +---------------+----------------+
                                    |
               +--------------------+--------------------+
               |                    |                     |
    +----------v--------+ +--------v----------+ +--------v---------+
    |  Identity Service  | |   Ad Management   | | Analytics Service |
    |  (Azure AD B2C /   | |     Service       | | (Azure Functions  |
    |   Duende Identity) | | (.NET 8 Web API)  | |  + Stream Analyt.)|
    +----------+--------+ +--------+----------+ +--------+---------+
               |                    |                     |
               |          +--------v----------+           |
               |          | Scheduling Service|           |
               |          |  (Hangfire / Azure|           |
               |          |   Functions)      |           |
               |          +--------+----------+           |
               |                    |                     |
    +----------v--------------------v---------------------v--------+
    |                     Azure SQL Database                        |
    |              (Managed / Elastic Pools)                        |
    +--------------------------------------------------------------+
               |                    |                     |
    +----------v--------+ +--------v----------+ +--------v---------+
    | Azure Blob Storage | |  Azure CDN        | | Azure Event Hubs  |
    | (Ad Media Assets)  | | (Content Delivery)| | (Telemetry Ingest)|
    +-------------------+ +-------------------+ +------------------+
                                                          |
                                                 +--------v---------+
                                                 |  Azure Stream     |
                                                 |  Analytics        |
                                                 +--------+---------+
                                                          |
                                                 +--------v---------+
                                                 |  Power BI /       |
                                                 |  Custom Dashboards|
                                                 +------------------+

    +--------------------------------------------------------------+
    |             Smart Screens (Android-based IoT Edge)            |
    |  - .NET MAUI / Android app for ad display                    |
    |  - Camera SDK for passenger counting                         |
    |  - 4G/5G cellular connectivity                               |
    |  - Azure IoT Hub for device management                       |
    +--------------------------------------------------------------+
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| **Frontend (Client Portal)** | Flutter (Web, iOS, Android) |
| **Backend Services** | C# / .NET 8, ASP.NET Core Web API |
| **Authentication** | Azure AD B2C / Duende IdentityServer, OAuth 2.0, JWT |
| **Database** | Azure SQL Database (relational), Azure Cosmos DB (telemetry/analytics) |
| **Ad Scheduling** | Hangfire (.NET) / Azure Functions (Timer Triggers) |
| **Content Storage** | Azure Blob Storage |
| **Content Delivery** | Azure CDN |
| **Real-time Analytics** | Azure Event Hubs + Azure Stream Analytics |
| **Dashboards** | Power BI Embedded / Custom Flutter dashboards |
| **Payment Gateway** | Stripe (primary), PayPal (secondary) |
| **IoT Device Mgmt** | Azure IoT Hub |
| **Smart Screens** | Android-based devices with .NET MAUI / native Android app |
| **CI/CD** | Azure DevOps Pipelines / GitHub Actions |
| **Monitoring** | Azure Application Insights, Azure Monitor |
| **Infrastructure** | Azure App Service, Azure Kubernetes Service (AKS), Azure Functions |
| **API Gateway** | Azure API Management |

---

## System Components

### 1. Flutter Client Application
Cross-platform client portal (web, iOS, Android) for advertisers and administrators.
- Campaign creation wizard with media upload
- Region targeting (urban, semi-urban, rural) and scheduling
- Real-time analytics dashboards
- Subscription and billing management
- Role-based views (Admin, Client, Operator)

### 2. Backend API (.NET 8)
Core business logic exposed as RESTful APIs behind Azure API Management.
- **Identity Service** - Authentication, authorization, RBAC via Azure AD B2C
- **Ad Management Service** - CRUD for campaigns, media assets, targeting rules
- **Scheduling Service** - Hangfire-based job scheduler for ad rotation and delivery windows
- **Subscription Service** - Plan management, Stripe/PayPal integration, invoicing
- **Content Delivery Service** - Signed URL generation, CDN cache management, media transcoding

### 3. Analytics Engine
Real-time and batch analytics pipeline for campaign performance metrics.
- **Ingestion** - Azure Event Hubs receives telemetry from smart screens (impressions, passenger counts, GPS)
- **Processing** - Azure Stream Analytics for real-time aggregation; Azure Functions for batch ETL
- **Storage** - Azure Cosmos DB for time-series telemetry; Azure SQL for aggregated reports
- **Visualization** - Power BI Embedded dashboards and custom Flutter charts

### 4. Content Delivery System
Manages the lifecycle of ad media from upload to screen display.
- Upload to Azure Blob Storage with automatic virus scanning
- Transcoding via Azure Media Services (if video)
- Distribution through Azure CDN with signed URLs for secure access
- Sync manifests pushed to screens via Azure IoT Hub

### 5. Smart Screen Software (IoT Edge)
Android-based embedded application running on vehicle-mounted LCD/LED screens.
- Receives ad playlists and media via Azure IoT Hub + CDN
- Displays ads according to schedule and geofence rules
- Camera-based anonymous passenger counting (on-device ML inference)
- Transmits telemetry (impressions, passenger count, GPS, connectivity status) to Event Hubs
- Offline-capable with local cache and sync-on-reconnect

### 6. Database Layer

| Database | Purpose |
|---|---|
| Azure SQL Database | Clients, subscriptions, campaigns, schedules, billing |
| Azure Cosmos DB | Screen telemetry, real-time analytics, time-series data |
| Azure Blob Storage | Ad media files (images, videos) |
| Azure Cache for Redis | Session cache, hot analytics data, rate limiting |

---

## System Workflow

### Client Onboarding
1. Client registers via Flutter app (web or mobile)
2. Azure AD B2C handles identity creation and email verification
3. Client selects a subscription plan and completes payment via Stripe
4. Profile and subscription stored in Azure SQL

### Ad Campaign Management
1. Client creates a campaign: uploads media, sets targeting regions, defines schedule
2. Media uploaded to Azure Blob Storage, validated and transcoded
3. Campaign metadata stored in Azure SQL; scheduling jobs created in Hangfire
4. Content manifest published to Azure CDN

### Content Delivery to Screens
1. Hangfire triggers scheduled content pushes
2. Azure IoT Hub sends playlist updates to target screens
3. Screens download media from Azure CDN using signed URLs
4. Ads displayed according to schedule and geofence rules

### Passenger Monitoring and Analytics
1. Smart screens run on-device ML model for anonymous passenger counting
2. Telemetry (impressions, passenger count, GPS coordinates) sent to Azure Event Hubs
3. Azure Stream Analytics processes events in real time
4. Aggregated metrics stored in Cosmos DB and Azure SQL
5. Clients view campaign performance in Flutter dashboard

### Subscription and Billing
1. Clients manage plans through Flutter portal
2. Stripe handles recurring billing, upgrades, and cancellations
3. Invoices generated and stored; webhook events update subscription status in Azure SQL

---

## Getting Started

### Prerequisites
- [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x+)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (for local services)
- [SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) (LocalDB or Docker)
- Stripe test API keys

### Local Development Setup

```bash
# Clone the repository
git clone https://github.com/Tone-j/ads_runner.git
cd ads_runner

# Backend
cd src/AdsRunner.Api
dotnet restore
dotnet ef database update
dotnet run

# Flutter Client
cd src/ads_runner_client
flutter pub get
flutter run -d chrome   # Web
flutter run              # Mobile (with emulator)
```

### Environment Configuration
Copy `appsettings.Development.json.example` to `appsettings.Development.json` and fill in:
- Azure SQL connection string
- Azure Blob Storage connection string
- Stripe API keys
- Azure AD B2C tenant configuration

---

## Project Structure

```
ads_runner/
├── src/
│   ├── AdsRunner.Api/                  # ASP.NET Core Web API (main backend)
│   │   ├── Controllers/                # API controllers
│   │   ├── Services/                   # Business logic services
│   │   ├── Models/                     # Domain models and DTOs
│   │   ├── Data/                       # EF Core DbContext and migrations
│   │   ├── Jobs/                       # Hangfire background jobs
│   │   └── appsettings.json
│   ├── AdsRunner.Identity/             # Identity service (Azure AD B2C config)
│   ├── AdsRunner.Analytics/            # Azure Functions for analytics processing
│   ├── AdsRunner.ContentDelivery/      # Content management and CDN integration
│   ├── AdsRunner.IoT/                  # IoT Hub device management
│   ├── AdsRunner.Shared/               # Shared models, utilities, contracts
│   └── ads_runner_client/              # Flutter client application
│       ├── lib/
│       │   ├── screens/                # UI screens
│       │   ├── widgets/                # Reusable widgets
│       │   ├── services/               # API service layer
│       │   ├── models/                 # Data models
│       │   ├── providers/              # State management
│       │   └── main.dart
│       └── pubspec.yaml
├── tests/
│   ├── AdsRunner.Api.Tests/            # Unit and integration tests
│   ├── AdsRunner.Analytics.Tests/
│   └── ads_runner_client_test/         # Flutter widget and integration tests
├── infra/
│   ├── bicep/                          # Azure Bicep IaC templates
│   ├── docker-compose.yml              # Local development services
│   └── pipelines/                      # Azure DevOps / GitHub Actions CI/CD
├── docs/
│   ├── api/                            # API documentation (Swagger/OpenAPI)
│   └── architecture/                   # Architecture decision records
├── .gitignore
├── AdsRunner.sln                       # Visual Studio solution file
└── README.md
```

---

## Deployment

### Azure Resources (provisioned via Bicep IaC)
- **Azure App Service** (or AKS) - Backend API hosting
- **Azure SQL Database** - Relational data
- **Azure Cosmos DB** - Telemetry and analytics
- **Azure Blob Storage** - Media assets
- **Azure CDN** - Content delivery
- **Azure AD B2C** - Identity provider
- **Azure Event Hubs** - Telemetry ingestion
- **Azure Stream Analytics** - Real-time processing
- **Azure IoT Hub** - Screen device management
- **Azure Application Insights** - Monitoring and diagnostics
- **Azure Key Vault** - Secrets management

### CI/CD Pipeline
The pipeline (Azure DevOps or GitHub Actions) automates:
1. Build and test .NET backend
2. Build and test Flutter client
3. Run security scanning (SAST/DAST)
4. Deploy to staging environment
5. Run integration tests against staging
6. Promote to production with blue-green deployment

---

## Scalability

| Strategy | Implementation |
|---|---|
| **Microservices** | Independent services deployed and scaled separately via AKS or App Service |
| **Auto-scaling** | Azure App Service / AKS horizontal pod autoscaler based on CPU and request metrics |
| **Database scaling** | Azure SQL Elastic Pools; Cosmos DB auto-scale RU/s |
| **CDN** | Azure CDN with edge caching for ad media; reduces origin load |
| **Event-driven** | Azure Event Hubs partitioned for high-throughput telemetry ingestion |
| **Caching** | Azure Cache for Redis for session, hot data, and rate limiting |
| **Load balancing** | Azure Front Door / Application Gateway for global traffic distribution |
| **Data partitioning** | Cosmos DB partition keys by screen ID; SQL sharding for multi-tenant isolation |

---

## Security

- **Authentication** - OAuth 2.0 / OpenID Connect via Azure AD B2C; JWT bearer tokens
- **Authorization** - Role-based access control (Admin, Client, Operator, Viewer)
- **Data encryption** - TLS 1.3 in transit; Azure SQL TDE and Blob Storage encryption at rest
- **Secrets management** - Azure Key Vault; no secrets in code or config files
- **API security** - Azure API Management with rate limiting, IP filtering, and WAF
- **Content security** - Signed URLs with expiry for media access; antivirus scanning on upload
- **Payment security** - PCI DSS compliance via Stripe; no card data stored
- **Monitoring** - Azure Sentinel for threat detection; Application Insights for anomaly alerts
- **Compliance** - POPIA/GDPR-aligned data handling; anonymous passenger counting (no PII)

---

## Roadmap

### Phase 1: Foundation (Weeks 1-2)
- Project scaffolding (.NET solution, Flutter app, Azure resource provisioning)
- Azure AD B2C integration and user authentication flow
- Azure SQL schema design and EF Core migrations
- Basic Flutter UI (login, registration, dashboard shell)
- CI/CD pipeline setup

### Phase 2: Core Features (Weeks 3-7)
- Client registration and onboarding flow
- Ad campaign CRUD (create, upload media, set targeting and schedule)
- Azure Blob Storage integration for media uploads
- Hangfire job scheduling for ad delivery
- Stripe subscription and payment integration
- RESTful API endpoints with Swagger documentation

### Phase 3: Advanced Features (Weeks 8-11)
- Smart screen software (Android app for ad display and passenger counting)
- Azure IoT Hub integration for device management
- Azure CDN setup for content delivery with signed URLs
- Analytics pipeline (Event Hubs -> Stream Analytics -> Cosmos DB)
- Real-time analytics dashboards in Flutter
- Geofencing and region-based ad targeting

### Phase 4: Hardening and Launch (Weeks 12-14)
- Unit, integration, and end-to-end testing
- Security audit and penetration testing
- Performance testing and optimization
- Blue-green deployment to production
- User acceptance testing
- Documentation and operational runbooks

---

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -m 'Add your feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a Pull Request

Please follow the [C# coding conventions](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions) and [Flutter style guide](https://dart.dev/effective-dart/style).

---

## Future Improvements

High-level enhancements to consider as the platform matures:

### Revenue and Business Model
- **Programmatic Ad Exchange** - Integrate with DSPs (Demand-Side Platforms) to allow real-time bidding (RTB) on screen inventory, opening revenue beyond direct subscriptions.
- **Dynamic Pricing Engine** - Price ad slots based on route popularity, time of day, passenger density, and demand using ML-driven pricing models.
- **White-Label Offering** - Package the platform as a white-label solution for other transit advertising companies to expand revenue streams.

### Intelligence and Targeting
- **AI-Powered Ad Optimization** - Use Azure Machine Learning to automatically optimize ad placement, rotation, and targeting based on historical performance data.
- **Contextual Targeting** - Leverage GPS + time-of-day + weather APIs to serve contextually relevant ads (e.g., cold drink ads on hot days, nearby restaurant ads at lunch).
- **Audience Segmentation** - Use anonymized demographic estimation (age group, crowd density) from camera feeds to enable audience-based targeting tiers.
- **A/B Testing Framework** - Allow clients to run A/B tests on creative variants and automatically promote the higher-performing ad.

### Platform Capabilities
- **Multi-Tenant Architecture** - Support multiple transit operators or cities as isolated tenants with shared infrastructure for cost efficiency.
- **Offline-First Screen Resilience** - Implement a robust offline queue with conflict resolution so screens in poor-connectivity areas never show blank screens.
- **Digital Twin for Fleet** - Build an Azure Digital Twins model of the vehicle fleet for real-time visualization of screen status, routes, and ad delivery across the network.
- **Self-Service Creative Builder** - Embed a drag-and-drop ad builder (HTML5 canvas-based) in the Flutter app so clients can design ads without external tools.

### Analytics and Reporting
- **Predictive Analytics** - Forecast campaign reach and ROI before launch using historical route and passenger data.
- **Heatmap Visualizations** - Show geographic heatmaps of ad exposure overlaid on city maps using Azure Maps.
- **Automated Reporting** - Schedule and email PDF/CSV campaign reports to clients weekly or monthly via Azure Logic Apps.
- **Competitive Benchmarking** - Provide anonymized industry benchmarks so clients can compare their campaign performance against averages.

### Operations and Reliability
- **Chaos Engineering** - Introduce Azure Chaos Studio experiments to validate system resilience under failure conditions.
- **Feature Flags** - Use Azure App Configuration feature flags for progressive rollouts and safe deployments.
- **Observability Stack** - Implement distributed tracing with OpenTelemetry across all services for end-to-end request visibility.
- **Screen Health Monitoring** - Real-time dashboard for operations team showing screen connectivity, storage, temperature, and error rates with automated alerting.

### Compliance and Trust
- **SOC 2 Type II Certification** - Pursue SOC 2 compliance to build enterprise client trust.
- **Audit Logging** - Immutable audit trail for all admin actions, campaign changes, and billing events stored in append-only Azure Table Storage.
- **Data Retention Policies** - Automated data lifecycle management with configurable retention and purge schedules per data category.

---

## License

This project is proprietary. All rights reserved.
