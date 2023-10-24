import 'package:dio/dio.dart';

/// 认证拦截器
class AuthInterceptor extends Interceptor {
  AuthInterceptor();
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 不需要认证
    final whitelist = ['/login', '/register'];
    if (whitelist.contains(options.path)) {
      return handler.next(options);
    }
    // 认证
    options.headers.addAll({'Authorization': 'access_token'});
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    super.onError(err, handler);
  }
}
