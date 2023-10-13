class SupabaseClientProviderConfiguration {
  SupabaseClientProviderConfiguration({
    required this.url,
    required this.anonKey,
    required this.deepLinkHostname,
  });

  final String url;
  final String anonKey;
  final String deepLinkHostname;
}
