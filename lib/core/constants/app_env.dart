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
}
