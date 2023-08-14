// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    Authenticated_Routes.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const Authenticated_Router(),
      );
    },
    Home_Route.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const Home_Page(),
      );
    },
    SignIn_Route.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SignIn_Page(),
      );
    },
    Unauthenticated_Routes.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const Unauthenticated_Router(),
      );
    },
  };
}

/// generated route for
/// [Authenticated_Router]
class Authenticated_Routes extends PageRouteInfo<void> {
  const Authenticated_Routes({List<PageRouteInfo>? children})
      : super(
          Authenticated_Routes.name,
          initialChildren: children,
        );

  static const String name = 'Authenticated_Routes';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [Home_Page]
class Home_Route extends PageRouteInfo<void> {
  const Home_Route({List<PageRouteInfo>? children})
      : super(
          Home_Route.name,
          initialChildren: children,
        );

  static const String name = 'Home_Route';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SignIn_Page]
class SignIn_Route extends PageRouteInfo<void> {
  const SignIn_Route({List<PageRouteInfo>? children})
      : super(
          SignIn_Route.name,
          initialChildren: children,
        );

  static const String name = 'SignIn_Route';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [Unauthenticated_Router]
class Unauthenticated_Routes extends PageRouteInfo<void> {
  const Unauthenticated_Routes({List<PageRouteInfo>? children})
      : super(
          Unauthenticated_Routes.name,
          initialChildren: children,
        );

  static const String name = 'Unauthenticated_Routes';

  static const PageInfo<void> page = PageInfo<void>(name);
}
