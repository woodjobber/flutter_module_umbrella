import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module_umbrella/src/jsbridge.dart';
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
      ..runJavaScriptReturningResult('navigator.userAgent').then((value) async {
        await controller.setUserAgent('$value com.jumei');
        controller.loadRequest(Uri.parse('http://jumei.com'),
            headers: {'address': 'beijing'});
      })
      ..addJavaScriptChannel('Toaster', onMessageReceived: (message) {
        // JSBridge.fromMap(jsonDecode(message.message));
        debugPrint(message.message);
      });
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
            IconButton(
              onPressed: () {
                controller.runJavaScript(
                    'Toaster.postMessage("User Agent: " + navigator.userAgent);');
              },
              icon: const Icon(Icons.dashboard),
            ),
          ],
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
