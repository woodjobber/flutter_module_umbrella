import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late final WebViewController controller;
  final channel = const MethodChannel('io.flutter.update.entrypoint');
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            debugPrint(request.url);
            if (request.url.startsWith('pattern')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter WebView'),
          leading: IconButton(
            onPressed: () {
              channel.invokeMethod('dismiss');
            },
            icon: const Icon(Icons.close_rounded),
          ),
          actions: [
            IconButton(
              onPressed: () {
                controller.goBack();
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ],
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
