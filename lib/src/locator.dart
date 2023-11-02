import 'package:flutter_module_umbrella/src/background_fetch_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => BackgroundFetchService());
}
