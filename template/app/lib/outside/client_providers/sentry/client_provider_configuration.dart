class Sentry_ClientProvider_Configuration {
  const Sentry_ClientProvider_Configuration({
    required this.dsn,
    required this.environment,
    required this.tracesSampleRate,
  });

  final String dsn;
  final String environment;
  final double tracesSampleRate;
}
