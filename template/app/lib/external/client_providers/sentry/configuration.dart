class SentryClientProviderConfiguration {
  const SentryClientProviderConfiguration({
    required this.dsn,
    required this.environment,
    required this.tracesSampleRate,
  });

  final String dsn;
  final String environment;
  final double tracesSampleRate;
}
