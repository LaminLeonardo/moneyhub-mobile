/// Configurações injetadas em tempo de build pelo pipeline
/// (flutter build ... --dart-define=APP_VERSION=x.y.z+sha).
class AppConfig {
  const AppConfig._();

  static const String version = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: 'dev',
  );
}
