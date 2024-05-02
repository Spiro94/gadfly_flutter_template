import 'package:amplitude_repository/amplitude_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:sentry_repository/sentry_repository.dart';
import '../blocs/redux_remote_devtools.dart';
import '../effects/now/provider.dart';
import '../effects/shared_preferences/provider.dart';
import '../effects/uuid/provider.dart';
import '../repositories/auth/repository.dart';
import 'app_bloc_observer.dart';
import 'app_builder.dart';
import 'configuration.dart';

Future<void> bootstrap({required MainConfiguration configuration}) async {
  final log = Logger('bootstrap');

  Logger.root.level = configuration.logLevel;
  Logger.root.onRecord.listen((record) {
    debugPrint(
      '[${record.loggerName}] ${record.level.name}: ${record.message}',
    );
  });
  log.finest('logger set up');

  FlutterError.onError = (details) {
    log.severe(details.exceptionAsString(), details.exception, details.stack);
  };
  log.finest('flutter onError callback set up');

  if (configuration.useReduxDevtools) {
    await createReduxRemoteDevtoolsStore(
      appLocalhost: MainConfigurations.appLocalhost,
    );
    log.finest('redux remote devtools started');
  }

  Future<void> _appRunner() async {
    WidgetsFlutterBinding.ensureInitialized();
    log.finest('ensure initialized');

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    log.finest('preferred orientations set');

    int? sessionId;

    final amplitudeRepository = AmplitudeRepository(
      configuration: configuration.amplitudeRepositoryConfiguration,
    );
    log.finer('amplitude repository created');
    await amplitudeRepository.init();
    log.finest('amplitude repository initialized');

    try {
      sessionId = await amplitudeRepository.amplitude?.getSessionId();
      log.info('amplitude repository set sessionId: $sessionId');
    } catch (_) {
      log.warning('Failed: amplitude repository set sessionId');
    }

    if (configuration.sentryRepositoryConfiguration != null) {
      if (sessionId != null) {
        SentryRepository.setSessionId(sessionId.toString());
        log.finest('sentry, session id set');
      }
    }

    final authRepository = AuthRepository();
    log.finer('auth repository created');

    Bloc.observer = AppBlocObserver();
    log.finer('bloc observer created');

    final nowEffectProvider = NowEffectProvider();
    log.finer('now effect provider created');

    final sharedPreferencesEffectProvider = SharedPreferencesEffectProvider(
      // TODO: replace with app name
      prefix: 'app',
    );
    log.finer('shared preferences effect provider created');
    await sharedPreferencesEffectProvider.init();
    log.finer('shared preferences effect provider initialized');

    final accessToken =
        sharedPreferencesEffectProvider.getEffect().getString('accessToken');

    final uuidEffectProvider = UuidEffectProvider();
    log.finer('uuid effect provider created');

    runApp(
      await appBuilder(
        deepLinkOverride: null,
        accessToken: accessToken,
        amplitudeRepository: amplitudeRepository,
        authRepository: authRepository,
        nowEffectProvider: nowEffectProvider,
        sharedPreferencesEffectProvider: sharedPreferencesEffectProvider,
        uuidEffectProvider: uuidEffectProvider,
      ),
    );
    log.info('app has started');
  }

  if (configuration.sentryRepositoryConfiguration != null) {
    final sentryRepository = SentryRepository(
      configuration: configuration.sentryRepositoryConfiguration!,
      appRunner: _appRunner,
    );
    log.finer('sentryRepository created');

    await sentryRepository.init();
    log.finest('sentryRepository initialized');
  } else {
    await _appRunner();
  }
}
