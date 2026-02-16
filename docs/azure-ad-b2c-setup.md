# Azure AD B2C Setup Guide

This document describes the Azure AD B2C configuration required for AdsRunner authentication.

---

## 1. Create Azure AD B2C Tenant

1. Go to **Azure Portal** > **Create a resource** > **Azure Active Directory B2C**
2. Choose **Create a new Azure AD B2C Tenant**
3. Organization name: `AdsRunner`
4. Initial domain name: `adsrunner` (results in `adsrunner.onmicrosoft.com`)
5. Complete the creation wizard

---

## 2. Register the API Application

1. In your B2C tenant, go to **App registrations** > **New registration**
2. Configure:
   - **Name**: `AdsRunner API`
   - **Supported account types**: Accounts in any identity provider or organizational directory
   - **Redirect URI**: Leave blank (API doesn't need one)
3. After creation, go to **Expose an API**:
   - Set **Application ID URI**: `https://adsrunner.onmicrosoft.com/api`
   - Add a scope:
     - **Scope name**: `access_as_user`
     - **Admin consent display name**: Access AdsRunner API
     - **Admin consent description**: Allows the app to access AdsRunner API on behalf of the signed-in user
     - **State**: Enabled
4. Note down:
   - **Application (client) ID** → This goes in `appsettings.json` as `AzureAdB2C:ClientId`
   - **Application ID URI** → Used as the audience

---

## 3. Register the SPA / Mobile Client Application

1. In **App registrations** > **New registration**
2. Configure:
   - **Name**: `AdsRunner Client`
   - **Supported account types**: Accounts in any identity provider or organizational directory
   - **Redirect URI**:
     - Type: **Single-page application (SPA)**
     - URI: `http://localhost:3000` (dev), `https://app.adsrunner.io` (prod)
3. After creation:
   - Go to **Authentication**:
     - Add additional redirect URIs as needed (mobile deep links)
     - Under **Implicit grant and hybrid flows**, check **ID tokens**
   - Go to **API permissions**:
     - **Add a permission** > **My APIs** > **AdsRunner API**
     - Select the `access_as_user` scope
     - **Grant admin consent**
4. Note down:
   - **Application (client) ID** → Used in Flutter `EnvironmentConfig.b2cClientId`

---

## 4. Create User Flows

In your B2C tenant, go to **User flows**:

### Sign up and sign in (B2C_1_SignUpSignIn)
- **Name**: `SignUpSignIn`
- **Identity providers**: Email signup, Google (optional), Microsoft (optional)
- **User attributes to collect**: Email Address, Given Name, Surname
- **Application claims to return**: Email Addresses, Given Name, Surname, User's Object ID

### Password reset (B2C_1_PasswordReset)
- **Name**: `PasswordReset`
- **Identity providers**: Reset password using email address

### Edit profile (B2C_1_EditProfile)
- **Name**: `EditProfile`
- **User attributes**: Given Name, Surname
- **Application claims**: Given Name, Surname, User's Object ID

---

## 5. Configure the API (appsettings.json)

```json
{
  "AzureAdB2C": {
    "Instance": "https://adsrunner.b2clogin.com",
    "Domain": "adsrunner.onmicrosoft.com",
    "TenantId": "<your-tenant-id>",
    "ClientId": "<api-application-client-id>",
    "SignUpSignInPolicyId": "B2C_1_SignUpSignIn",
    "ResetPasswordPolicyId": "B2C_1_PasswordReset",
    "EditProfilePolicyId": "B2C_1_EditProfile"
  }
}
```

---

## 6. Token Validation Flow

1. **Flutter client** redirects user to B2C sign-in page
2. User authenticates (email/password or social login)
3. B2C issues a **JWT access token** with configured claims
4. Flutter stores the token securely via `AuthStorage`
5. Flutter includes the token in API requests: `Authorization: Bearer <token>`
6. **.NET API** validates the token using `Microsoft.Identity.Web`:
   - Validates issuer (B2C tenant)
   - Validates audience (API client ID)
   - Validates signature (B2C public keys)
   - Extracts claims (oid, email, name)
7. `[Authorize]` attribute enforces authentication on protected endpoints
8. `ICurrentUserService` extracts the user's B2C object ID from claims

---

## 7. Testing Locally

Without a B2C tenant configured, the API will reject all authenticated requests.
For local development without B2C:

1. Comment out the `[Authorize]` attribute on controllers
2. Or configure a development-only JWT issuer for testing
3. The `/api/v1/auth/health` endpoint is always accessible (no auth required)

---

## 8. Useful Links

- [Microsoft Identity Web documentation](https://learn.microsoft.com/en-us/azure/active-directory-b2c/enable-authentication-web-api)
- [Azure AD B2C user flows](https://learn.microsoft.com/en-us/azure/active-directory-b2c/user-flow-overview)
- [Configure token claims](https://learn.microsoft.com/en-us/azure/active-directory-b2c/configure-tokens)
