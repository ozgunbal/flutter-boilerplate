import 'flavor_values.dart';

enum Flavor { dev, staging, prod }

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() => _instance;

  AppConfig._internal();

  late Flavor flavor;
  late FlavorValues values;

  static void initialize(Flavor flavor) {
    _instance.flavor = flavor;
    _instance.values = _getValues(flavor);
  }

  // Get the appropriate flavor values
  static FlavorValues _getValues(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        return FlavorValues(
          baseUrl: 'https://dev-api.example.com',
          appName: 'MyApp Dev',
          appId: 'com.example.flutter_boilerplate.dev',
          enableLogging: true,
          databaseName: 'myapp_dev.db',
        );
      case Flavor.staging:
        return FlavorValues(
          baseUrl: 'https://staging-api.example.com',
          appName: 'MyApp Staging',
          appId: 'com.example.flutter_boilerplate.staging',
          enableLogging: true,
          databaseName: 'myapp_staging.db',
        );
      case Flavor.prod:
        return FlavorValues(
          baseUrl: 'https://api.example.com',
          appName: 'MyApp',
          appId: 'com.example.flutter_boilerplate',
          enableLogging: false,
          databaseName: 'myapp.db',
        );
    }
  }

  // Convenience getters
  bool get isDev => flavor == Flavor.dev;

  bool get isStaging => flavor == Flavor.staging;

  bool get isProd => flavor == Flavor.prod;
}
