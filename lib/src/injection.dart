import 'package:flutter_module_umbrella/src/rest_client.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger(printer: PrettyPrinter());

class Injection extends GetxService {
  Future<Injection> init() async {
    await Get.putAsync<SharedPreferences>(
        () async => await SharedPreferences.getInstance());
    Get.lazyPut(() => RestClient(), fenix: true);
    return this;
  }

  Future<void> incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    logger.d('Pressed $counter times.');
    await prefs.setInt('counter', counter);
  }

  int get counter => Get.find<SharedPreferences>().getInt('counter') ?? 0;
}
