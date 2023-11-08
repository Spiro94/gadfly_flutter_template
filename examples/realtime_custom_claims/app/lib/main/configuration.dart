import 'package:amplitude_repository/amplitude_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:sentry_repository/sentry_repository.dart';
import 'package:supabase_client_provider/supabase_client_provider.dart';

// TODO: Update 'CHANGE ME'

class MainConfigurations {
  static MainConfiguration development = MainConfiguration(
    logLevel: Level.ALL,
    useReduxDevtools: false,
    amplitudeRepositoryConfiguration: AmplitudeRepositoryConfiguration(
      apiKey: 'CHANGE_ME',
      sendEvents: false,
    ),
    sentryRepositoryConfiguration: null,
    supabaseClientProviderConfiguration: SupabaseClientProviderConfiguration(
      url: 'http://localhost:54321',
      anonKey:
          '''eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0''',
      deepLinkHostname: kIsWeb
          ? 'http://localhost:3000'
          : 'com.example.realtime-custom-claims.deep://deeplink-callback',
    ),
  );

  static MainConfiguration developmentWithReduxDevtools = MainConfiguration(
    logLevel: Level.ALL,
    useReduxDevtools: true,
    amplitudeRepositoryConfiguration: AmplitudeRepositoryConfiguration(
      apiKey: 'CHANGE_ME',
      sendEvents: false,
    ),
    sentryRepositoryConfiguration: null,
    supabaseClientProviderConfiguration: SupabaseClientProviderConfiguration(
      url: 'http://localhost:54321',
      anonKey:
          '''eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0''',
      deepLinkHostname: kIsWeb
          ? 'http://localhost:3000'
          : 'com.example.realtime-custom-claims.deep://deeplink-callback',
    ),
  );

  static MainConfiguration developmentAndSendEvents = MainConfiguration(
    logLevel: Level.ALL,
    useReduxDevtools: true,
    amplitudeRepositoryConfiguration: AmplitudeRepositoryConfiguration(
      apiKey: 'CHANGE_ME',
      sendEvents: true,
    ),
    sentryRepositoryConfiguration: SentryRepositoryConfiguration(
      sentryDSN: 'CHANGE ME',
      sentryEnvironment: 'CHANG ME',
    ),
    supabaseClientProviderConfiguration: SupabaseClientProviderConfiguration(
      url: 'http://localhost:54321',
      anonKey:
          '''eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0''',
      deepLinkHostname: kIsWeb
          ? 'http://localhost:3000'
          : 'com.example.realtime-custom-claims.deep://deeplink-callback',
    ),
  );

  static MainConfiguration production = MainConfiguration(
    logLevel: Level.INFO,
    useReduxDevtools: false,
    amplitudeRepositoryConfiguration: AmplitudeRepositoryConfiguration(
      apiKey: 'CHANGE_ME',
      sendEvents: true,
    ),
    sentryRepositoryConfiguration: SentryRepositoryConfiguration(
      sentryDSN: 'CHANGE ME',
      sentryEnvironment: 'CHANGE ME',
    ),
    supabaseClientProviderConfiguration: SupabaseClientProviderConfiguration(
      url: 'CHANGE ME',
      anonKey: 'CHANGE ME',
      deepLinkHostname: 'CHANGE ME',
    ),
  );
}

class MainConfiguration {
  MainConfiguration({
    required this.logLevel,
    required this.useReduxDevtools,
    required this.amplitudeRepositoryConfiguration,
    required this.sentryRepositoryConfiguration,
    required this.supabaseClientProviderConfiguration,
  });

  final Level logLevel;
  final bool useReduxDevtools;
  final AmplitudeRepositoryConfiguration amplitudeRepositoryConfiguration;
  final SentryRepositoryConfiguration? sentryRepositoryConfiguration;
  final SupabaseClientProviderConfiguration supabaseClientProviderConfiguration;
}
