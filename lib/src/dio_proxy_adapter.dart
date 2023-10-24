import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

/// Methods for managing proxies on [Dio]
extension ProxyX on Dio {
  /// Use a proxy to connect to the internet.
  ///
  /// If [proxyUrl] is a non-empty, non-null String, connect to the proxy server,exp: localhost:8888.

  void useProxy(String? proxyUrl) {
    if (proxyUrl != null && proxyUrl.trim().isNotEmpty) {
      (httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient()
          ..idleTimeout = const Duration(seconds: 3)
          ..findProxy = (url) {
            return 'PROXY $proxyUrl;';
          }
          ..badCertificateCallback = (cert, host, post) => true;
        return client;
      };
    }
  }
}
