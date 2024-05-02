import 'dart:ui';
import 'package:amplitude_repository/amplitude_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
// ignore: depend_on_referenced_packages
import 'package:sentry_flutter/sentry_flutter.dart';
import '../blocs/auth/bloc.dart';
import '../blocs/auth/state.dart';
import '../effects/now/provider.dart';
import '../effects/shared_preferences/provider.dart';
import '../effects/uuid/provider.dart';
import '../i18n/translations.g.dart';
import '../repositories/auth/repository.dart';
import '../routes/app_router.dart';
import '../theme/theme.dart';

final _log = Logger('app_builder');

Future<Widget> appBuilder({
  required String? deepLinkOverride,
  required String? accessToken,
  required AmplitudeRepository amplitudeRepository,
  required AuthRepository authRepository,
  required NowEffectProvider nowEffectProvider,
  required SharedPreferencesEffectProvider sharedPreferencesEffectProvider,
  required UuidEffectProvider uuidEffectProvider,
  Key? key,
}) async {
  const locale = AppLocale.en;
  _log.fine('app locale: ${locale.name}');
  LocaleSettings.setLocale(locale);

  _log.fine('access token:\n$accessToken');
  // TODO: validate token
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
    sharedPreferencesEffect: sharedPreferencesEffectProvider.getEffect(),
    initialState: authState,
  );

  return BlocProvider.value(
    value: authBloc,
    child: TranslationProvider(
      child: App(
        key: key,
        deepLinkOverride: deepLinkOverride,
        authBloc: authBloc,
        amplitudeRepository: amplitudeRepository,
        authRepository: authRepository,
        nowEffectProvider: nowEffectProvider,
        sharedPreferencesEffectProvider: sharedPreferencesEffectProvider,
        uuidEffectProvider: uuidEffectProvider,
      ),
    ),
  );
}

class App extends StatelessWidget {
  App({
    required this.deepLinkOverride,
    required AuthBloc authBloc,
    required this.amplitudeRepository,
    required this.authRepository,
    required this.nowEffectProvider,
    required this.sharedPreferencesEffectProvider,
    required this.uuidEffectProvider,
    super.key,
  }) : _appRouter = AppRouter(authBloc: authBloc);

  final String? deepLinkOverride;

  final AmplitudeRepository amplitudeRepository;
  final AuthRepository authRepository;

  final NowEffectProvider nowEffectProvider;
  final SharedPreferencesEffectProvider sharedPreferencesEffectProvider;
  final UuidEffectProvider uuidEffectProvider;

  final AppRouter _appRouter;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      // Effect Providers
      providers: [
        RepositoryProvider<NowEffectProvider>.value(
          value: nowEffectProvider,
        ),
        RepositoryProvider<SharedPreferencesEffectProvider>.value(
          value: sharedPreferencesEffectProvider,
        ),
        RepositoryProvider<UuidEffectProvider>.value(
          value: uuidEffectProvider,
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
        ],
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
    );
  }
}
