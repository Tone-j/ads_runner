// Azure AD B2C Reference Module
//
// Azure AD B2C tenants cannot be provisioned via Bicep/ARM.
// This file documents the required B2C configuration.
//
// Manual Setup Required:
// 1. Create Azure AD B2C tenant via Azure Portal
// 2. Register API application:
//    - Name: AdsRunner API
//    - Expose an API: set Application ID URI
//    - Add scopes: access_as_user
// 3. Register SPA/Mobile application:
//    - Name: AdsRunner Client
//    - Redirect URIs: http://localhost:3000, https://app.adsrunner.io
//    - Enable implicit grant: ID tokens
//    - API permissions: add AdsRunner API scopes
// 4. Create User Flows:
//    - B2C_1_SignUpSignIn (Sign up and sign in)
//    - B2C_1_PasswordReset (Password reset)
//    - B2C_1_EditProfile (Profile editing)
// 5. Configure token claims:
//    - Include: email, given_name, family_name, oid
//
// See docs/azure-ad-b2c-setup.md for detailed instructions.

// This is a documentation-only module — no resources deployed.
