class SupabaseClientProviderConfiguration {
  SupabaseClientProviderConfiguration({
    required this.url,
    required this.anonKey,
    required this.authCallbackUrlHostname,
  });

  final String url;
  final String anonKey;
  final String authCallbackUrlHostname;
}
