import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../blocs/auth/bloc.dart';
import '../blocs/auth/event.dart';
import '../blocs/auth/state.dart';
import '../pages/authenticated/home/page.dart';
import '../pages/authenticated/reset_password/page.dart';
import '../pages/authenticated/router.dart';
import '../pages/unauthenticated/forgot_flow/forgot_password/page.dart';
import '../pages/unauthenticated/forgot_flow/forgot_password_confirmation/page.dart';
import '../pages/unauthenticated/forgot_flow/router.dart';
import '../pages/unauthenticated/router.dart';
import '../pages/unauthenticated/sign_in/page.dart';
import '../pages/unauthenticated/sign_up/page.dart';
import '../shared/validators.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  AppRouter({
    required this.authBloc,
  });

  final AuthBloc authBloc;

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  late final List<AutoRoute> routes = [
    AutoRoute(
      path: '/anon',
      page: Unauthenticated_Routes.page,
      guards: [UnauthGuard(authBloc: authBloc)],
      children: [
        AutoRoute(
          path: '',
          initial: true,
          page: SignIn_Route.page,
        ),
        AutoRoute(
          path: 'signUp',
          page: SignUp_Route.page,
        ),
        AutoRoute(
          path: 'forgot',
          page: ForgotFlow_Routes.page,
          children: [
            AutoRoute(
              path: 'password',
              page: ForgotPassword_Route.page,
            ),
            AutoRoute(
              path: 'passwordConfirmation',
              page: ForgotPasswordConfirmation_Route.page,
              guards: [ForgotPasswordConfirgmationGuard()],
            ),
          ],
        ),
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      path: '/',
      page: Authenticated_Routes.page,
      guards: [AuthGuard(authBloc: authBloc)],
      children: [
        AutoRoute(
          initial: true,
          path: '',
          page: Home_Route.page,
        ),
        AutoRoute(
          path: 'resetPassword',
          page: ResetPassword_Route.page,
        ),
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    RedirectRoute(path: '*', redirectTo: '/'),
  ];
}

Future<DeepLink> deepLinkBuilder({
  required AuthBloc authBloc,
  required PlatformDeepLink deepLink,
  required String? deepLinkOverride,
}) async {
  if (deepLink.path.startsWith('/deep') ||
      (deepLinkOverride?.startsWith('/deep') ?? false)) {
    final path = deepLinkOverride ?? deepLink.path;

    switch (path) {
      case '/deep/resetPassword':
        try {
          final completer = Completer<void>();

          authBloc.add(
            AuthEvent_SetSessionFromDeepLink(
              completer: completer,
              uri: deepLink.uri,
            ),
          );

          await completer.future;

          // While the path is more susceptible to break when refectoring, we
          // were only able to get path to create the stack correctly.
          return const DeepLink.path(
            '/resetPassword',
            includePrefixMatches: true,
          );
        } catch (_) {}
      default:
        break;
    }
  }

  return deepLink;
}

class AuthGuard extends AutoRouteGuard {
  AuthGuard({required this.authBloc});

  final AuthBloc authBloc;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (authBloc.state.status == AuthStatus.authenticated) {
      resolver.next();
    } else {
      router.root.replaceAll(const [SignIn_Route()]);
    }
  }
}

class UnauthGuard extends AutoRouteGuard {
  UnauthGuard({required this.authBloc});

  final AuthBloc authBloc;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (authBloc.state.status == AuthStatus.unauthentcated) {
      resolver.next();
    } else {
      // coverage:ignore-start
      router.root.replaceAll(const [Home_Route()]);
      // coverage:ignore-end
    }
  }
}

/// Should only be able to get to this page if there is an email query parameter
class ForgotPasswordConfirgmationGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final email = resolver.route.queryParams.optString('email');
    if (email != null &&
        email.isNotEmpty &&
        isEmailValid(Uri.decodeComponent(email))) {
      resolver.next();
    } else {
      // coverage:ignore-start
      router.root.replaceAll(const [SignIn_Route()]);
      // coverage:ignore-end
    }
  }
}
