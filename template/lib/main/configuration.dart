import 'package:logging/logging.dart';
import 'package:supabase_client_provider/supabase_client_provider.dart';

// TODO: Update 'CHANGE ME'

class MainConfigurations {
  static MainConfiguration development = MainConfiguration(
    logLevel: Level.ALL,
    useReduxDevtools: false,
    supabaseClientProviderConfiguration: SupabaseClientProviderConfiguration(
      url: 'http://localhost:54321',
      authCallbackUrlHostname: 'http://localhost:3000',
      anonKey: 'CHANGE ME',
    ),
  );

  static MainConfiguration developmentWithReduxDevtools = MainConfiguration(
    logLevel: Level.ALL,
    useReduxDevtools: true,
    supabaseClientProviderConfiguration: SupabaseClientProviderConfiguration(
      url: 'http://localhost:54321',
      authCallbackUrlHostname: 'http://localhost:3000',
      anonKey: 'CHANGE ME',
    ),
  );

  static MainConfiguration production = MainConfiguration(
    logLevel: Level.INFO,
    useReduxDevtools: false,
    supabaseClientProviderConfiguration: SupabaseClientProviderConfiguration(
      url: 'CHANGE ME',
      authCallbackUrlHostname: 'CHANGE ME',
      anonKey: 'CHANGE ME',
    ),
  );
}

class MainConfiguration {
  MainConfiguration({
    required this.logLevel,
    required this.useReduxDevtools,
    required this.supabaseClientProviderConfiguration,
  });

  final Level logLevel;
  final bool useReduxDevtools;
  final SupabaseClientProviderConfiguration supabaseClientProviderConfiguration;
}
