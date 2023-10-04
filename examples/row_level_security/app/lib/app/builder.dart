import 'dart:ui';
import 'package:amplitude_repository/amplitude_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:sentry_flutter/sentry_flutter.dart';
import '../blocs/auth/bloc.dart';
import '../blocs/auth/state.dart';
import '../effects/auth_change/provider.dart';
import '../effects/now/provider.dart';
import '../i18n/translations.g.dart';
import '../repositories/auth/repository.dart';
// ATTENTION 1/6
import '../repositories/count/repository.dart';
// ---
import 'router.dart';
import 'theme/theme.dart';
import 'widgets/listener/subscribe_to_auth_change.dart';

Future<Widget> appBuilder({
  required String? deepLinkOverride,
  required String? accessToken,
  required AmplitudeRepository amplitudeRepository,
  required AuthChangeEffectProvider authChangeEffectProvider,
  required NowEffectProvider nowEffectProvider,
  required AuthRepository authRepository,
  // ATTENTION 2/6
  required CountRepository countRepository,
  // ---
  Key? key,
}) async {
  LocaleSettings.setLocale(AppLocale.en);

  final authState = accessToken != null && accessToken.isNotEmpty
      ? AuthState(
          status: AuthStatus.authenticated,
          accessToken: accessToken,
        )
      : const AuthState(
          status: AuthStatus.unauthentcated,
          accessToken: null,
        );

  final authBloc = AuthBloc(
    authRepository: authRepository,
    initialState: authState,
  );

  return BlocProvider.value(
    value: authBloc,
    child: TranslationProvider(
      child: App(
        key: key,
        deepLinkOverride: deepLinkOverride,
        amplitudeRepository: amplitudeRepository,
        authChangeEffectProvider: authChangeEffectProvider,
        nowEffectProvider: nowEffectProvider,
        authBloc: authBloc,
        authRepository: authRepository,
        // ATTENTION 3/6
        countRepository: countRepository,
        // ---
      ),
    ),
  );
}

class App extends StatelessWidget {
  App({
    required this.deepLinkOverride,
    required this.amplitudeRepository,
    required this.authChangeEffectProvider,
    required this.nowEffectProvider,
    required AuthBloc authBloc,
    required this.authRepository,
    // ATTENTION 4/6
    required this.countRepository,
    // ---
    super.key,
  }) : _appRouter = AppRouter(authBloc: authBloc);

  final String? deepLinkOverride;
  final AmplitudeRepository amplitudeRepository;
  final AuthChangeEffectProvider authChangeEffectProvider;
  final NowEffectProvider nowEffectProvider;
  final AuthRepository authRepository;
  // ATTENTION 5/6
  final CountRepository countRepository;
  // --

  final AppRouter _appRouter;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      // Effects
      providers: [
        RepositoryProvider<AuthChangeEffectProvider>.value(
          value: authChangeEffectProvider,
        ),
        RepositoryProvider<NowEffectProvider>.value(
          value: nowEffectProvider,
        ),
      ],
      child: MultiRepositoryProvider(
        // Repositories
        providers: [
          RepositoryProvider<AmplitudeRepository>.value(
            value: amplitudeRepository,
          ),
          RepositoryProvider<AuthRepository>.value(
            value: authRepository,
          ),
          // ATTENTION 6/6
          RepositoryProvider<CountRepository>.value(
            value: countRepository,
          ),
          // ---
        ],
        child: AppL_SubscribeToAuthChange(
          child: MaterialApp.router(
            theme: appTheme,
            debugShowCheckedModeBanner: false,
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: TranslationProvider.of(context).flutterLocale,
            supportedLocales: AppLocaleUtils.supportedLocales,
            routeInformationParser: _appRouter.defaultRouteParser(
              includePrefixMatches: true,
            ),
            routerDelegate: AutoRouterDelegate(
              _appRouter,
              deepLinkBuilder: (deepLink) => deepLinkBuilder(
                authBloc: context.read<AuthBloc>(),
                deepLink: deepLink,
                deepLinkOverride: deepLinkOverride,
              ),
              navigatorObservers: () => [
                SentryNavigatorObserver(),
                AmplitudeRouteObserver(
                  amplitudeRepository: amplitudeRepository,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
