class EnvironmentConfig {
  static const ENV = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const API_HOST =
      String.fromEnvironment('API_HOST', defaultValue: 'makasu.co');
}
