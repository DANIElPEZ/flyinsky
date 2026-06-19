import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as tabs;
import 'package:app_links/app_links.dart';

class VatsimAuthService {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  Future<Map<String, dynamic>?> loginWithVatsim(BuildContext context, String authUrl) async {
    final completer = Completer<Map<String, dynamic>?>();
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri uri) {
      if (uri.scheme == 'flyinsky' && uri.host == 'auth') {
        final token = uri.queryParameters['access_token'];
        final expiresInStr = uri.queryParameters['expires_in'];

        if (token != null) {
          final expiresIn = int.tryParse(expiresInStr ?? '3600') ?? 3600;
          final DateTime expirationDate = DateTime.now().add(Duration(seconds: expiresIn));

          tabs.closeCustomTabs();
          completer.complete({
            'token': token,
            'day': expirationDate.day,
            'month': expirationDate.month,
            'year': expirationDate.year,
          });
        }
      }
    }, onError: (err) {
      if (!completer.isCompleted) completer.complete(null);
    });
    try {
      await tabs.launchUrl(
        Uri.parse(authUrl),
        customTabsOptions: tabs.CustomTabsOptions(
          colorSchemes: tabs.CustomTabsColorSchemes.defaults(
            toolbarColor: Theme.of(context).primaryColor,
          ),
          urlBarHidingEnabled: true,
          showTitle: true,
        ),
      );
    } catch (e) {
      debugPrint("Error al abrir Custom Tabs: $e");
      if (!completer.isCompleted) completer.complete(null);
    }
    final result = await completer.future;
    _linkSubscription?.cancel();
    return result;
  }
}