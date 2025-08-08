import 'config/app/app_config.dart';
import 'main.dart';

void main() {
  AppConfig.initialize(Flavor.staging);

  mainCommon();
}
