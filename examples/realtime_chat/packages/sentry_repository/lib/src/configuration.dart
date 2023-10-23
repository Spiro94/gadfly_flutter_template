/// {@template sentryRepository.configuration}
/// The configuration for the `SentryRepository`
/// {@endtemplate}
class SentryRepositoryConfiguration {
  /// {@macro sentryRepository.configuration}
  SentryRepositoryConfiguration({
    required this.sentryDSN,
    required this.sentryEnvironment,
  });

  /// The DSN for Sentry
  final String sentryDSN;

  /// The environment for Sentry
  final String sentryEnvironment;
}
