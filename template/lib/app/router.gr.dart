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
    ForgotFlow_Routes.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ForgotFlow_Router(),
      );
    },
    ForgotPasswordConfirmation_Route.name: (routeData) {
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<ForgotPasswordConfirmation_RouteArgs>(
          orElse: () => ForgotPasswordConfirmation_RouteArgs(
              email: queryParams.optString('email')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ForgotPasswordConfirmation_Page(
          email: args.email,
          key: args.key,
        ),
      );
    },
    ForgotPassword_Route.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ForgotPassword_Page(),
      );
    },
    Home_Route.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const Home_Page(),
      );
    },
    ResetPassword_Route.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ResetPassword_Page(),
      );
    },
    SignIn_Route.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SignIn_Page(),
      );
    },
    SignUp_Route.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SignUp_Page(),
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
/// [ForgotFlow_Router]
class ForgotFlow_Routes extends PageRouteInfo<void> {
  const ForgotFlow_Routes({List<PageRouteInfo>? children})
      : super(
          ForgotFlow_Routes.name,
          initialChildren: children,
        );

  static const String name = 'ForgotFlow_Routes';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ForgotPasswordConfirmation_Page]
class ForgotPasswordConfirmation_Route
    extends PageRouteInfo<ForgotPasswordConfirmation_RouteArgs> {
  ForgotPasswordConfirmation_Route({
    String? email,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ForgotPasswordConfirmation_Route.name,
          args: ForgotPasswordConfirmation_RouteArgs(
            email: email,
            key: key,
          ),
          rawQueryParams: {'email': email},
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordConfirmation_Route';

  static const PageInfo<ForgotPasswordConfirmation_RouteArgs> page =
      PageInfo<ForgotPasswordConfirmation_RouteArgs>(name);
}

class ForgotPasswordConfirmation_RouteArgs {
  const ForgotPasswordConfirmation_RouteArgs({
    this.email,
    this.key,
  });

  final String? email;

  final Key? key;

  @override
  String toString() {
    return 'ForgotPasswordConfirmation_RouteArgs{email: $email, key: $key}';
  }
}

/// generated route for
/// [ForgotPassword_Page]
class ForgotPassword_Route extends PageRouteInfo<void> {
  const ForgotPassword_Route({List<PageRouteInfo>? children})
      : super(
          ForgotPassword_Route.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPassword_Route';

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
/// [ResetPassword_Page]
class ResetPassword_Route extends PageRouteInfo<void> {
  const ResetPassword_Route({List<PageRouteInfo>? children})
      : super(
          ResetPassword_Route.name,
          initialChildren: children,
        );

  static const String name = 'ResetPassword_Route';

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
/// [SignUp_Page]
class SignUp_Route extends PageRouteInfo<void> {
  const SignUp_Route({List<PageRouteInfo>? children})
      : super(
          SignUp_Route.name,
          initialChildren: children,
        );

  static const String name = 'SignUp_Route';

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
