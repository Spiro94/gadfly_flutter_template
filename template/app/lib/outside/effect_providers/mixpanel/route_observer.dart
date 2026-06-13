import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'effect.dart';

class Mixpanel_Effect_RouteObserver extends AutoRouteObserver {
  Mixpanel_Effect_RouteObserver({required this.mixpanelEffect});

  final Mixpanel_Effect mixpanelEffect;

  void _trackPage({required Route<dynamic> route, required bool isPopped}) {
    // We use widgets ending in `_Routes` to coordinate pages. Because of this,
    // we do not report `_Routes` screens and only report `_Page` screens.
    if (route.settings.name != null &&
        !route.settings.name!.contains('_Routes')) {
      mixpanelEffect.trackPage(
        pageName: route.settings.name!,
        isPopped: isPopped,
      );
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _trackPage(route: route, isPopped: true);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _trackPage(route: route, isPopped: false);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    if (newRoute != null) {
      _trackPage(route: newRoute, isPopped: false);
    }
  }
}
