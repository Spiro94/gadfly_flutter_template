import 'package:amplitude_repository/src/repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// {@template amplitudeRepository.routeObserver}
/// A route observer that will fire page events to Amplitude
/// {@endtemplate}
class AmplitudeRouteObserver extends AutoRouteObserver {
  /// {@macro amplitudeRepository.routeObserver}
  AmplitudeRouteObserver({
    required this.amplitudeRepository,
  });

  /// A refernce to the [AmplitudeRepository]
  final AmplitudeRepository amplitudeRepository;

  void _sendPageEvent({
    required Route<dynamic> route,
    required Route<dynamic>? previousRoute,
    required bool popped,
  }) {
    // We use widgets ending in _Flow to coordinate pages. Because of this, we
    // do not report _Flow screens and on report _Page screens.
    if (route.settings.name != null && !route.settings.name!.contains('Flow')) {
      amplitudeRepository.page(
        event: route.settings.name!,
        popped: popped,
      );
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _sendPageEvent(
        route: previousRoute,
        previousRoute: route,
        popped: true,
      );
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _sendPageEvent(
      route: route,
      previousRoute: previousRoute,
      popped: false,
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    if (newRoute != null) {
      _sendPageEvent(
        route: newRoute,
        previousRoute: oldRoute,
        popped: false,
      );
    }
  }
}
