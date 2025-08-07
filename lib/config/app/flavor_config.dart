import 'app_config.dart';
import 'flavor_values.dart';

class FlavorConfig {
  static Flavor? _flavor;
  static FlavorValues? _values;

  static Flavor get flavor => _flavor!;

  static FlavorValues get values => _values!;

  static void initialize(Flavor flavor, FlavorValues values) {
    _flavor = flavor;
    _values = values;
  }

  static bool get isDevelopment => _flavor == Flavor.dev;

  static bool get isStaging => _flavor == Flavor.staging;

  static bool get isProduction => _flavor == Flavor.prod;
}
