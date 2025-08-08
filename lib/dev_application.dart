import 'config/app/app_config.dart';
import 'main.dart';

void main() {
  AppConfig.initialize(Flavor.dev);

  mainCommon();
}
