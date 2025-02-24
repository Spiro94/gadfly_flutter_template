// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import '../configurations/configuration.dart';
import '../external/client_providers/all.dart';
import '../external/client_providers/supabase/client_provider.dart';
import '../external/effect_providers/all.dart';
import '../external/effect_providers/auth_change/provider.dart';
import '../external/effect_providers/mixpanel/provider.dart';
import '../external/repositories/all.dart';
import '../external/repositories/auth/repository.dart';
import '../internal/blocs/observer.dart';
import 'builder.dart';

/// This function runs our application. This is where we do any kind of setup
/// that needs to happen before [appBuilder] is called. For example, this is
/// were we initialize our external dependencies, such as repositories and
/// effect providers.
Future<void> appRunner({
  required AppConfiguration configuration,
}) async {
  // Set up logging (1 of 2)
  _setUpLogging(logLevel: configuration.logLevel);

  WidgetsFlutterBinding.ensureInitialized();

  final sessionId = const Uuid().v4();

  // Create and initialize client providers
  final clientProviders = AllClientProviders(
    supabaseClientProvider: SupabaseClientProvider(
      configuration: configuration.clientProvidersConfigurations.supabase,
    ),
  );
  await clientProviders.initialize();

  // Create and initialize effect providers
  final effectProviders = AllEffectProviders(
    authChangeEffectProvider: AuthChangeEffectProvider(
      supabaseClient: clientProviders.supabaseClientProvider.client,
    ),
    mixpanelEffectProvider: MixpanelEffectProvider(
      sessionId: sessionId,
      configuration: configuration.effectProvidersConfigurations.mixpanel,
    ),
  );
  await effectProviders.initialize();

  // Set up logging again (2 of 2)
  // Note: we are setting up logging a second time, because supabase is adding
  // its own logging listener and we want to stop it and replace it with ours.
  _setUpLogging(logLevel: configuration.logLevel);

  // Create and initialize repositories
  final repositories = AllRepositories(
    authRepository: AuthRepository(
      deepLinkBaseUri: configuration.deepLinkBaseUri,
      supabaseClient: clientProviders.supabaseClientProvider.client,
    ),
  );
  await repositories.initialize();

  // Setup Bloc Observer
  // Reminder that this should be after logging is set up
  Bloc.observer = AppBlocObserver();

  // Get access token if there is one
  final accessToken = clientProviders
      .supabaseClientProvider.client.auth.currentSession?.accessToken;

  final app = await appBuilder(
    key: const Key('app'),
    deepLinkFragmentOverride: null,
    appLocale: configuration.appLocale,
    materialThemeData: configuration.materialThemeData,
    foruiThemeData: configuration.foruiThemeData,
    accessToken: accessToken,
    clientProviders: clientProviders,
    effectProviders: effectProviders,
    repositories: repositories,
  );
  runApp(app);
}

void _setUpLogging({required Level logLevel}) {
  Logger.root.level = logLevel;
  Logger.root.clearListeners();
  Logger.root.onRecord.listen((record) {
    final message =
        '''[${record.loggerName}] ${record.level}: ${record.message}''';

    if (record.stackTrace != null) {
      debugPrint('''$message\n${record.error}''');
    } else {
      debugPrint(message);
    }
  });
}
