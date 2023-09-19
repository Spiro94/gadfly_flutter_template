import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../blocs/auth/bloc.dart';
import '../blocs/auth/state.dart';
import '../effects/auth_change/provider.dart';
import '../effects/now/provider.dart';
import '../i18n/translations.g.dart';
import '../repositories/auth/repository.dart';
import 'router.dart';
import 'theme/theme.dart';
import 'widgets/listener/subscribe_to_auth_change.dart';

Future<Widget> appBuilder({
  required String? deepLinkOverride,
  required String? accessToken,
  required AuthChangeEffectProvider authChangeEffectProvider,
  required NowEffectProvider nowEffectProvider,
  required AuthRepository authRepository,
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
        authChangeEffectProvider: authChangeEffectProvider,
        nowEffectProvider: nowEffectProvider,
        authBloc: authBloc,
        authRepository: authRepository,
      ),
    ),
  );
}

class App extends StatelessWidget {
  App({
    required this.deepLinkOverride,
    required this.authChangeEffectProvider,
    required this.nowEffectProvider,
    required AuthBloc authBloc,
    required this.authRepository,
    super.key,
  }) : _appRouter = AppRouter(authBloc: authBloc);

  final String? deepLinkOverride;
  final AuthChangeEffectProvider authChangeEffectProvider;
  final NowEffectProvider nowEffectProvider;
  final AuthRepository authRepository;

  final AppRouter _appRouter;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthChangeEffectProvider>.value(
          value: authChangeEffectProvider,
        ),
        RepositoryProvider<NowEffectProvider>.value(
          value: nowEffectProvider,
        ),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthRepository>.value(
            value: authRepository,
          ),
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
            ),
          ),
        ),
      ),
    );
  }
}
