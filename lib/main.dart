import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_module_login/flutter_module_login.dart';
import 'package:flutter_module_register/flutter_module_register.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(UmbrellaApp(
    route: WidgetsBinding.instance.platformDispatcher.defaultRouteName,
  ));
}

class UmbrellaApp extends StatelessWidget {
  const UmbrellaApp({
    super.key,
    required this.route,
  });
  final String route;
  @override
  Widget build(BuildContext context) {
    stdout.writeln("++++++ $route");
    return switch (route) {
      UmbrellaModules.login => const LoginPage(),
      UmbrellaModules.register => const RegisterPage(),
      _ => const ErrorApp(),
    };
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: const Text('error'),
        ),
      ),
    );
  }
}

class UmbrellaModules {
  static const login = 'login_module';
  static const register = 'register_module';
}
