enum Environment { development, staging, production }

class EnvironmentConfig {
  static Environment current = Environment.development;

  static String get apiBaseUrl => switch (current) {
        Environment.development => 'https://localhost:5001/api/v1',
        Environment.staging => 'https://api-staging.adsrunner.io/v1',
        Environment.production => 'https://api.adsrunner.io/v1',
      };

  static String get b2cAuthority => switch (current) {
        Environment.development =>
          'https://{tenant}.b2clogin.com/{tenant}.onmicrosoft.com/B2C_1_SignUpSignIn',
        Environment.staging =>
          'https://{tenant}.b2clogin.com/{tenant}.onmicrosoft.com/B2C_1_SignUpSignIn',
        Environment.production =>
          'https://{tenant}.b2clogin.com/{tenant}.onmicrosoft.com/B2C_1_SignUpSignIn',
      };

  static String get b2cClientId => switch (current) {
        Environment.development => '{dev-client-id}',
        Environment.staging => '{staging-client-id}',
        Environment.production => '{prod-client-id}',
      };

  static List<String> get b2cScopes => [
        'https://{tenant}.onmicrosoft.com/api/access_as_user',
      ];
}
