import 'dart:developer';

import 'package:flutter/material.dart';

class TrackingNavigatorObserver extends NavigatorObserver {
  void logPush(final String tab, final String message) {
    log(message, name: 'Go - $tab');
  }

  void logPop(final String tab, final String message) {
    log(message, name: 'Go - $tab:');
  }

  @override
  void didPush(final Route<dynamic> route, final Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == null) {
      logPop('Push', 'Dialog');
    } else {
      logPush('Push', route.settings.name.toString());
    }
  }

  @override
  void didPop(final Route<dynamic> route, final Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route.settings.name == null) {
      logPop('Pop', 'Dialog');
    } else {
      logPop('Pop', route.settings.name.toString());
    }
  }

  @override
  void didReplace({
    final Route<dynamic>? newRoute,
    final Route<dynamic>? oldRoute,
  }) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    debugPrint(
      '[Go] replaced: ${oldRoute?.settings.name} → ${newRoute?.settings.name}',
    );
  }
}
