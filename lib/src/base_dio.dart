import 'package:dio/dio.dart';
import 'package:flutter_module_umbrella/src/auth_interceptor.dart';
import 'package:flutter_module_umbrella/src/dio_proxy_adapter.dart';
import 'package:flutter_module_umbrella/src/header_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class BaseDio {
  BaseDio._();
  static BaseDio? _instance;

  static final BaseOptions _baseOptions = BaseOptions(
    connectTimeout: const Duration(milliseconds: 50000),
    receiveTimeout: const Duration(milliseconds: 30000),
    sendTimeout: const Duration(milliseconds: 30000),
  );

  static final Dio _dio = Dio(_baseOptions)
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      error: true,
      compact: true,
    ))
    ..interceptors.add(AuthInterceptor())
    ..interceptors.add(HeaderInterceptor())
    ..useProxy(const bool.fromEnvironment('CHARLES_PROXY_IP')
        ? const String.fromEnvironment('CHARLES_PROXY_IP')
        : null);

  Dio get dio => _dio;

  static BaseDio instance() {
    _instance ??= BaseDio._();
    return _instance!;
  }

  factory BaseDio() => BaseDio.instance();
}
