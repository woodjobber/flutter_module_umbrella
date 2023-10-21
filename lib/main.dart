import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module_login/flutter_module_login.dart';
import 'package:flutter_module_register/flutter_module_register.dart';

StreamSubscription<bool>? _subscription;

void main() async {
  const chanel = MethodChannel("io.flutter.update.entrypoint");
  CustomFlutterBinding();
  await initialize();

  chanel.setMethodCallHandler((call) async {
    return await runAppForRoute(call);
  });
  final route = WidgetsBinding.instance.platformDispatcher.defaultRouteName;

  runApp(widgetForRoute(route));
}

Future runAppForRoute(MethodCall call) async {
  final route = call.arguments.toString();
  debugPrint(route);
  if (call.method == "destroy.flutter.app") {
    _subscription?.cancel();
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
    UmbrellaModules.splash => const CommandPage(
        key: ValueKey(3),
      ),
    _ => const EmptyApp(
        key: ValueKey(4),
      ),
  };
}

class EmptyApp extends StatelessWidget {
  const EmptyApp({super.key});

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
    Future.delayed(const Duration(seconds: 2)).then((value) {
      completer.sink.add(true);
    });

    return MaterialApp(
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
}
