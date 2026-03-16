import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VatsimWebView extends StatefulWidget {
  final String authUrl;
  final String redirectUrl;

  const VatsimWebView({required this.authUrl, required this.redirectUrl});

  @override
  State<VatsimWebView> createState() => _VatsimWebViewState();
}

class _VatsimWebViewState extends State<VatsimWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(widget.redirectUrl)) {
              final uri = Uri.parse(request.url);
              final code = uri.queryParameters['code'];

              if (code != null) {
                Navigator.pop(context, code);
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.authUrl));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}