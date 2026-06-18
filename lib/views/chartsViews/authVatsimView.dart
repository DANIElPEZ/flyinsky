import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VatsimWebView extends StatefulWidget {
  final String webAuth;

  const VatsimWebView({required this.webAuth});

  @override
  State<VatsimWebView> createState() => _VatsimWebViewState();
}

class _VatsimWebViewState extends State<VatsimWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setUserAgent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.contains('/success')) {
                  final uri = Uri.parse(request.url);
                  final token = uri.queryParameters['access_token'];
                  final expiresInStr = uri.queryParameters['expires_in'];

                  if (token != null) {
                    final expiresIn = int.tryParse(expiresInStr ?? '3600') ?? 3600;
                    final DateTime expirationDate = DateTime.now().add(Duration(seconds: expiresIn));

                    Navigator.pop(context, {
                      'token': token,
                      'day': expirationDate.day,
                      'month': expirationDate.month,
                      'year': expirationDate.year,
                    });
                  }
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              }
            )
          )
          ..loadRequest(Uri.parse(widget.webAuth));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}