import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// This package should come with flutter, so we aren't depending on it
// explicitly
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:forui/forui.dart';
import 'package:logging/logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../external/effect_providers/all.dart';
import '../external/effect_providers/mixpanel/route_observer.dart';
import '../external/repositories/all.dart';
import '../internal/blocs/auth/bloc.dart';
import '../internal/blocs/auth/state.dart';
import '../internal/i18n/translations.g.dart';
import '../internal/routes/deep_link_handler.dart';
import '../internal/routes/router.dart';

final _log = Logger('app_builder');

/// This function builds the root widget for our application.
Future<Widget> appBuilder({
  required Key key,
  required AppLocale appLocale,
  required ThemeData materialThemeData,
  required FThemeData foruiThemeData,
  required String? accessToken,
  required String? deepLinkFragmentOverride,
  required AllEffectProviders effectProviders,
  required AllRepositories repositories,
}) async {
  // Set locale
  await LocaleSettings.setLocale(appLocale);
  _log.info('locale: ${appLocale.languageCode}');

  // Set access token if there is one
  _log.fine('access token:\n$accessToken');
  final authState = accessToken != null && accessToken.isNotEmpty
      ? AuthState(
          status: AuthStatus.authenticated,
          accessToken: accessToken,
        )
      : const AuthState(
          status: AuthStatus.unauthentcated,
          accessToken: null,
        );

  // Special case: create AuthBloc outside of widget tree, because it is
  // required by AppRouter, which needs to be created above the widget tree.
  final authBloc = AuthBloc(
    authRepository: repositories.authRepository,
    initialState: authState,
  );

  final appNavigatorKey = GlobalKey<NavigatorState>();

  final appRouter = AppRouter(
    authBloc: authBloc,
    navigatorKey: appNavigatorKey,
  );

  final deepLinkHandler = DeepLinkHandler(
    appNavigatorKey: appNavigatorKey,
    authBloc: authBloc,
    foruiThemeData: foruiThemeData,
  );

  return TranslationProvider(
    child: App(
      key: key,
      deepLinkFragmentOverride: deepLinkFragmentOverride,
      deepLinkHandler: deepLinkHandler,
      materialThemeData: materialThemeData,
      foruiThemeData: foruiThemeData,
      authBloc: authBloc,
      appRouter: appRouter,
      effectProviders: effectProviders,
      repositories: repositories,
    ),
  );
}

class App extends StatelessWidget {
  const App({
    required this.deepLinkFragmentOverride,
    required this.deepLinkHandler,
    required this.materialThemeData,
    required this.foruiThemeData,
    required this.authBloc,
    required this.appRouter,
    required this.effectProviders,
    required this.repositories,
    super.key,
  });

  final String? deepLinkFragmentOverride;
  final DeepLinkHandler deepLinkHandler;
  final ThemeData materialThemeData;
  final FThemeData foruiThemeData;
  final AuthBloc authBloc;
  final AllEffectProviders effectProviders;
  final AllRepositories repositories;

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        ...effectProviders.createProviders(),
        ...repositories.createProviders(),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authBloc),
        ],
        child: MaterialApp.router(
          theme: materialThemeData,
          builder: (context, child) {
            return FTheme(
              data: foruiThemeData,
              child: child ?? const FScaffold(content: SizedBox()),
            );
          },
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
            FLocalizations.delegate,
          ],
          locale: TranslationProvider.of(context).flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          routeInformationParser: appRouter.defaultRouteParser(
            includePrefixMatches: true,
          ),
          routerDelegate: AutoRouterDelegate(
            appRouter,
            rebuildStackOnDeepLink: true,
            deepLinkBuilder: (deepLink) => deepLinkHandler.handleDeepLink(
              deepLink: deepLink,
              deepLinkFragmentOverride: deepLinkFragmentOverride,
            ),
            navigatorObservers: () => [
              AutoRouteObserver(),
              MixpanelRouteObserver(
                mixpanelEffect:
                    effectProviders.mixpanelEffectProvider.getEffect(),
              ),
              SentryNavigatorObserver(),
            ],
          ),
        ),
      ),
    );
  }
}
