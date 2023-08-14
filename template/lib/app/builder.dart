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
import '../effects/now/provider.dart';
import '../effects/shared_preferences/provider.dart';
import '../i18n/translations.g.dart';
import '../repositories/auth/repository.dart';
import 'router.dart';

Future<Widget> appBuilder({
  required ThemeMode themeMode,
  required ThemeData themeDataLight,
  required ThemeData themeDataDark,
  required NowEffectProvider nowEffectProvider,
  required SharedPreferencesEffectProvider sharedPreferencesEffectProvider,
  required AuthRepository authRepository,
  required AmplitudeRepository amplitudeRepository,
}) async {
  LocaleSettings.setLocale(AppLocale.en);

  final _sharedPreferences = sharedPreferencesEffectProvider.getEffect();

  final authToken =
      _sharedPreferences.getString(AuthBloc.authTokenSharedPrefsKey);

  final authState = authToken != null && authToken.isNotEmpty
      ? AuthState(
          status: AuthStatus.authenticated,
          authToken: authToken,
          signInStatus: AuthSignInStatus.idle,
        )
      : const AuthState(
          status: AuthStatus.unauthentcated,
          authToken: null,
          signInStatus: AuthSignInStatus.idle,
        );

  final authBloc = AuthBloc(
    sharedPreferences: _sharedPreferences,
    authRepository: authRepository,
    amplitudeRepository: amplitudeRepository,
    initialState: authState,
  );

  return BlocProvider.value(
    value: authBloc,
    child: TranslationProvider(
      child: App(
        themeMode: themeMode,
        themeDataLight: themeDataLight,
        themeDataDark: themeDataDark,
        nowEffectProvider: nowEffectProvider,
        sharedPreferencesEffectProvider: sharedPreferencesEffectProvider,
        authBloc: authBloc,
        amplitudeRepository: amplitudeRepository,
      ),
    ),
  );
}

class App extends StatelessWidget {
  App({
    required this.themeMode,
    required this.themeDataLight,
    required this.themeDataDark,
    required this.nowEffectProvider,
    required this.sharedPreferencesEffectProvider,
    required AuthBloc authBloc,
    required this.amplitudeRepository,
    super.key,
  }) : _appRouter = AppRouter(authBloc: authBloc);

  final ThemeMode themeMode;
  final ThemeData themeDataLight;
  final ThemeData themeDataDark;

  final NowEffectProvider nowEffectProvider;
  final SharedPreferencesEffectProvider sharedPreferencesEffectProvider;

  final AmplitudeRepository amplitudeRepository;

  final AppRouter _appRouter;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NowEffectProvider>.value(
          value: nowEffectProvider,
        ),
        RepositoryProvider<SharedPreferencesEffectProvider>.value(
          value: sharedPreferencesEffectProvider,
        ),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AmplitudeRepository>.value(
            value: amplitudeRepository,
          ),
        ],
        child: MaterialApp.router(
          themeMode: themeMode,
          theme: themeDataLight,
          darkTheme: themeDataDark,
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
            initialRoutes: [],
            navigatorObservers: () => [
              SentryNavigatorObserver(),
              AmplitudeRouteObserver(
                amplitudeRepository: amplitudeRepository,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
