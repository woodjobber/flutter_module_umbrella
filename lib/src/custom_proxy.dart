import 'dart:io';

import 'custom_http_override.dart';

/// Allows you to set and enable a proxy for your app
class CustomProxy {
  /// A string representing an IP address for the proxy server
  final String ipAddress;

  /// The port number for the proxy server
  /// Can be null if port is default.
  final int port;

  /// Set this to true
  /// - Warning: Setting this to true in production apps can be dangerous. Use with care!
  bool allowBadCertificates;

  /// Initializer
  CustomProxy(
      {required this.ipAddress,
      required this.port,
      this.allowBadCertificates = true});

  /// Initializer from string
  /// Note: Uses static method, rather than named init to allow final properties.
  static CustomProxy? fromString(
    String proxy, {
    bool allowBadCertificates = true,
  }) {
    // Check if valid
    if (proxy.trim().isEmpty) {
      assert(
          false, "Proxy string passed to CustomProxy.fromString() is invalid.");
      return null;
    }

    // Build and return
    final proxyParts = proxy.split(":");
    final ipAddress = proxyParts[0];
    final port = proxyParts.isNotEmpty ? int.tryParse(proxyParts[1]) : 0;
    return CustomProxy(
      ipAddress: ipAddress,
      port: port!,
      allowBadCertificates: allowBadCertificates,
    );
  }

  /// Enable the proxy
  void enable() {
    HttpOverrides.global = CustomProxyHttpOverride.withProxy(
      toString(),
      allowBadCertificates: allowBadCertificates,
    );
  }

  /// Disable the proxy
  void disable() {
    HttpOverrides.global = null;
  }

  @override
  String toString() {
    String proxy = ipAddress;
    proxy += ":$port";
    return proxy;
  }
}
