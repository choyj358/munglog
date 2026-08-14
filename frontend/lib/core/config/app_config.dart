class AppConfig {
  const AppConfig._();

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  static const devUserId = String.fromEnvironment(
    'DEV_USER_ID',
    defaultValue: '1',
  );

  static const skipAuth = bool.fromEnvironment(
    'SKIP_AUTH',
    defaultValue: false,
  );
}
