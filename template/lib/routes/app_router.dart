import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:logging/logging.dart';

import '../blocs/auth/bloc.dart';
import 'authenticated/guard.dart';
import 'authenticated/home/page.dart';
import 'authenticated/router.dart';

import 'unauthenticated/guard.dart';
import 'unauthenticated/router.dart';
import 'unauthenticated/sign_in/page.dart';

part 'app_router.gr.dart';

final _log = Logger('router');

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  AppRouter({
    required this.authBloc,
  });

  final AuthBloc authBloc;

  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  late final List<AutoRoute> routes = [
    AutoRoute(
      path: '/anon',
      page: Unauthenticated_Routes.page,
      guards: [UnauthenticatedGuard(authBloc: authBloc)],
      children: [
        AutoRoute(
          path: 'signIn',
          initial: true,
          page: SignIn_Route.page,
        ),
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      path: '/',
      page: Authenticated_Routes.page,
      guards: [AuthenticatedGuard(authBloc: authBloc)],
      children: [
        AutoRoute(
          initial: true,
          path: '',
          page: Home_Route.page,
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
  _log.info('deeplink: ${deepLinkOverride ?? deepLink.uri}');

  if (deepLink.path.startsWith('/deep') || (deepLinkOverride != null)) {
    // coverage:ignore-start
    final path = deepLinkOverride ?? deepLink.path;
    // coverage:ignore-end

    final handledDeepLink = await handleDeepLink(
      uri: deepLink.uri,
      path: path,
      authBloc: authBloc,
    );
    if (handledDeepLink != null) {
      return DeepLink.path(handledDeepLink, includePrefixMatches: true);
    }
  }

  return deepLink;
}

Future<String?> handleDeepLink({
  required Uri uri,
  required String path,
  required AuthBloc authBloc,
}) async {
  switch (path) {
    // TODO: handle deep links here
    default:
      return path;
  }
}
