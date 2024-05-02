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
import '../effects/auth_change/provider.dart';
import '../effects/now/provider.dart';
import '../effects/play_audio/provider.dart';
import '../effects/record_audio/provider.dart';
import '../effects/uuid/provider.dart';
import '../i18n/translations.g.dart';
import '../repositories/audio/repository.dart';
import '../repositories/auth/repository.dart';
import '../theme/theme.dart';
import 'router.dart';
import 'widgets/connector/auth_change_listener.dart';
import 'widgets/connector/deep_links_listener.dart';

final _log = Logger('app_builder');

Future<Widget> appBuilder({
  required String? deepLinkOverride,
  required Stream<Uri> deepLinkStream,
  required String? accessToken,
  required AmplitudeRepository amplitudeRepository,
  required AudioRepository audioRepository,
  required AuthRepository authRepository,
  required AuthChangeEffectProvider authChangeEffectProvider,
  required NowEffectProvider nowEffectProvider,
  required PlayAudioEffectProvider playAudioEffectProvider,
  required RecordAudioEffectProvider recordAudioEffectProvider,
  required UuidEffectProvider uuidEffectProvider,
  Key? key,
}) async {
  const locale = AppLocale.en;
  _log.fine('app locale: ${locale.name}');
  LocaleSettings.setLocale(locale);

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
        deepLinkStream: deepLinkStream,
        authBloc: authBloc,
        audioRepository: audioRepository,
        amplitudeRepository: amplitudeRepository,
        authRepository: authRepository,
        authChangeEffectProvider: authChangeEffectProvider,
        nowEffectProvider: nowEffectProvider,
        playAudioEffectProvider: playAudioEffectProvider,
        recordAudioEffectProvider: recordAudioEffectProvider,
        uuidEffectProvider: uuidEffectProvider,
      ),
    ),
  );
}

class App extends StatelessWidget {
  App({
    required this.deepLinkOverride,
    required this.deepLinkStream,
    required AuthBloc authBloc,
    required this.amplitudeRepository,
    required this.audioRepository,
    required this.authRepository,
    required this.authChangeEffectProvider,
    required this.nowEffectProvider,
    required this.playAudioEffectProvider,
    required this.recordAudioEffectProvider,
    required this.uuidEffectProvider,
    super.key,
  }) : _appRouter = AppRouter(authBloc: authBloc);

  final String? deepLinkOverride;
  final Stream<Uri> deepLinkStream;

  final AudioRepository audioRepository;
  final AmplitudeRepository amplitudeRepository;
  final AuthRepository authRepository;

  final AuthChangeEffectProvider authChangeEffectProvider;
  final NowEffectProvider nowEffectProvider;
  final PlayAudioEffectProvider playAudioEffectProvider;
  final RecordAudioEffectProvider recordAudioEffectProvider;
  final UuidEffectProvider uuidEffectProvider;

  final AppRouter _appRouter;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      // Effect Providers
      providers: [
        RepositoryProvider<AuthChangeEffectProvider>.value(
          value: authChangeEffectProvider,
        ),
        RepositoryProvider<NowEffectProvider>.value(
          value: nowEffectProvider,
        ),
        RepositoryProvider<PlayAudioEffectProvider>.value(
          value: playAudioEffectProvider,
        ),
        RepositoryProvider<RecordAudioEffectProvider>.value(
          value: recordAudioEffectProvider,
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
          RepositoryProvider<AudioRepository>.value(
            value: audioRepository,
          ),
          RepositoryProvider<AuthRepository>.value(
            value: authRepository,
          ),
        ],
        child: AppC_DeepLinksListener(
          appRouter: _appRouter,
          deepLinksStream: deepLinkStream,
          child: AppC_AuthChangeListener(
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
      ),
    );
  }
}
