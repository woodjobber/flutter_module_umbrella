import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module_login/flutter_module_login.dart';
import 'package:flutter_module_register/flutter_module_register.dart';
import 'package:flutter_module_umbrella/src/base_dio.dart';
import 'package:flutter_module_umbrella/src/custom_proxy.dart';
import 'package:flutter_module_umbrella/src/injection.dart';
import 'package:flutter_module_umbrella/src/object_ext.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

StreamSubscription<bool>? _subscription;

void main(List<String> arguments) async {
  const chanel = MethodChannel("io.flutter.update.entrypoint");
  CustomFlutterBinding();
  await initialize();
  await initServices();
  chanel.setMethodCallHandler((call) async {
    /// proxy
    if (call.method == 'proxy') {
      final args = call.arguments;
      final ip = args['ip'].toString();
      final port = args['port'].toString().toInt() ?? 8888;
      if (kDebugMode) {
        // '192.168.1.7'
        logger.d('PROXY $ip:$port');
        CustomProxy(ipAddress: ip, port: port).enable();
        BaseDio.instance().dio.get('http://date.jsontest.com/');
      }
      return null;
    }
    return await runAppForRoute(call);
  });
  final route = WidgetsBinding.instance.platformDispatcher.defaultRouteName;
  runApp(widgetForRoute(route));
}

Future runAppForRoute(MethodCall call) async {
  final route = call.arguments.toString();
  debugPrint(route);
  _subscription?.cancel();
  if (call.method == "destroy.flutter.app") {
    _subscription = null;
    runApp(widgetForRoute(route));
    return Future.value(null);
  }

  /// 防止 手速过快 导致 页面混乱 【快闪】 无法一次性进入目标页面
  StreamController<bool> completer = StreamController<bool>();
  _subscription = completer.stream.listen((event) {
    runApp(widgetForRoute(route));
  });

  runApp(SplashPage(
    completer: completer,
    key: const ValueKey(100),
  ));
  return Future.value(null);
}

Widget widgetForRoute(String route) {
  return switch (route) {
    UmbrellaModules.login => const LoginPage(
        key: ValueKey(1),
      ),
    UmbrellaModules.register => const RegisterPage(
        key: ValueKey(2),
      ),
    UmbrellaModules.splash || UmbrellaModules.intl => const CommandPage(
        key: ValueKey(3),
      ),
    _ => const PlaceholderApp(
        key: ValueKey(4),
      ),
  };
}

Future<void> initServices() async {
  await Get.putAsync<Injection>(() async => await Injection().init());
  await GetStorage.init();
}

class PlaceholderApp extends StatelessWidget {
  const PlaceholderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Material(
          child: Container(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

class SplashPage extends StatelessWidget {
  final StreamController<bool> completer;

  const SplashPage({required this.completer, Key? key}) : super(key: key);
  final bool animated = false;
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: animated ? 7 : 2)).then((value) {
      if (!completer.isClosed && completer.hasListener) {
        completer.sink.add(true);
        Get.find<Injection>().incrementCounter();
      }
    });

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepPurple,
        body: Material(
          child: Container(
            alignment: Alignment.center,
            color: Colors.deepPurple,
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: FlutterLogo(
                    size: 100,
                  ),
                ),
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.orangeAccent,
                  ),
                ),
                Positioned(
                  top: 100,
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: animated
                        ? SizedBox(
                            width: 250.0,
                            child: TextLiquidFill(
                              text: '北京欢迎您！',
                              waveColor: Colors.orangeAccent,
                              boxBackgroundColor: Colors.deepPurple,
                              textStyle: const TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent),
                              boxHeight: 100.0,
                            ),
                          )
                        : const Text(
                            '北京欢迎您！',
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.orangeAccent),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UmbrellaModules {
  static const login = 'login_module';
  static const register = 'register_module';
  static const splash = 'splash';
  static const intl = 'intl';
  static const defaultName = '/';
}
