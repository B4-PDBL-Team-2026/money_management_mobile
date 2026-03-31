class AppEnv {
  const AppEnv._();

  static const bool useMockApi = bool.fromEnvironment(
    'USE_MOCK_API',
    defaultValue: false,
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000/api',
  );

  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '',
  );

  static const String environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static const String release = String.fromEnvironment(
    'APP_RELEASE',
    defaultValue: 'money_management_mobile@dev',
  );

  static const String sentryTracesSampleRate = String.fromEnvironment(
    'SENTRY_TRACES_SAMPLE_RATE',
    defaultValue: '0.0',
  );
}
