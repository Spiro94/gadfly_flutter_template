import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../shared/mixins/logging.dart';
import '../blocs/auth/bloc.dart';
import 'authenticated/guard.dart';
import 'authenticated/home/page.dart';
import 'authenticated/reset_password/page.dart';
import 'authenticated/router.dart';
import 'unauthenitcated/email_verification_link_sent/page.dart';
import 'unauthenitcated/forgot_password_flow/forgot_password/page.dart';
import 'unauthenitcated/forgot_password_flow/reset_password_link_sent/guard.dart';
import 'unauthenitcated/forgot_password_flow/reset_password_link_sent/page.dart';
import 'unauthenitcated/forgot_password_flow/router.dart';
import 'unauthenitcated/guard.dart';
import 'unauthenitcated/router.dart';
import 'unauthenitcated/sign_in/page.dart';
import 'unauthenitcated/sign_up/page.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class Routes_router extends RootStackRouter with SharedMixin_Logging {
  Routes_router({
    required this.authBloc,
    required super.navigatorKey,
  });

  final Auth_Bloc authBloc;

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/anon',
          page: Unauthenticated_Routes.page,
          guards: [Unauthenticated_Guard(authBloc: authBloc)],
          children: [
            AutoRoute(
              path: 'sign-in',
              initial: true,
              page: SignIn_Route.page,
            ),
            AutoRoute(
              path: 'sign-in/sign-up',
              page: SignUp_Route.page,
            ),
            AutoRoute(
              path: 'sign-in/email-verification-link-sent',
              page: EmailVerificationLinkSent_Route.page,
            ),
            AutoRoute(
              path: 'sign-in/forgot-password-flow',
              page: ForgotPasswordFlow_Routes.page,
              children: [
                AutoRoute(
                  path: 'forgot-password',
                  page: ForgotPassword_Route.page,
                ),
                AutoRoute(
                  path: 'reset-password-link-sent',
                  page: ResetPasswordLinkSent_Route.page,
                  guards: [
                    ResetPasswordLinkSent_Guard(),
                  ],
                ),
              ],
            ),
            RedirectRoute(path: '*', redirectTo: 'sign-in'),
          ],
        ),
        AutoRoute(
          path: '/',
          page: Authenticated_Routes.page,
          guards: [Authenticated_Guard(authBloc: authBloc)],
          children: [
            AutoRoute(
              initial: true,
              path: 'home',
              page: Home_Route.page,
            ),
            AutoRoute(
              path: 'home/reset-password',
              page: ResetPassword_Route.page,
            ),
            RedirectRoute(path: '*', redirectTo: 'home'),
          ],
        ),
        RedirectRoute(path: '*', redirectTo: '/home'),
      ];
}
