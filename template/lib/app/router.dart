import 'package:auto_route/auto_route.dart';

import '../blocs/auth/bloc.dart';
import '../blocs/auth/state.dart';
import '../pages/authenticated/home/page.dart';
import '../pages/authenticated/router.dart';
import '../pages/unauthenticated/router.dart';
import '../pages/unauthenticated/sign_in/page.dart';

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
      path: '/sign',
      page: Unauthenticated_Routes.page,
      guards: [UnauthGuard(authBloc: authBloc)],
      children: [
        AutoRoute(
          path: 'in',
          initial: true,
          page: SignIn_Route.page,
        ),
        RedirectRoute(path: '*', redirectTo: 'in'),
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
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
  ];
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
