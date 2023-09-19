import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:supabase_client_provider/supabase_client_provider.dart';
import '../app/bloc_observer.dart';
import '../app/builder.dart';
import '../blocs/redux_remote_devtools.dart';
import '../effects/auth_change/provider.dart';
import '../effects/now/provider.dart';
import '../repositories/auth/repository.dart';
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
    await createReduxRemoteDevtoolsStore();
    log.finest('redux remote devtools started');
  }

  WidgetsFlutterBinding.ensureInitialized();
  log.finest('ensure initialized');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  log.finest('preferred orientations set');

  Bloc.observer = AppBlocObserver();
  log.finer('bloc observer created');

  final nowEffectProvider = NowEffectProvider();
  log.finer('now effect provider created');

  final supabaseClientProvider = SupabaseClientProvider(
    config: configuration.supabaseClientProviderConfiguration,
  );
  log.finest('supabase client provider created');

  await supabaseClientProvider.init();
  log.finest('supabase client initialzed');

  final authRepository = AuthRepository(
    authCallbackUrlHostname: configuration
        .supabaseClientProviderConfiguration.authCallbackUrlHostname,
    supabaseClient: supabaseClientProvider.client,
  );
  log.finer('auth repository created');

  final authChangeEffectProvider = AuthChangeEffectProvider(
    supabaseClient: supabaseClientProvider.client,
  );
  log.finer('auth change effect provider created');

  runApp(
    await appBuilder(
      deepLinkOverride: null,
      accessToken:
          supabaseClientProvider.client.auth.currentSession?.accessToken,
      authChangeEffectProvider: authChangeEffectProvider,
      nowEffectProvider: nowEffectProvider,
      authRepository: authRepository,
    ),
  );
  log.info('app has started');
}
