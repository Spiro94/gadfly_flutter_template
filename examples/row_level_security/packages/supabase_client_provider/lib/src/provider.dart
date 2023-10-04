import 'package:supabase_client_provider/src/configuration.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientProvider {
  SupabaseClientProvider({
    required this.config,
  });

  final SupabaseClientProviderConfiguration config;

  Future<void> init() async {
    await Supabase.initialize(
      url: config.url,
      anonKey: config.anonKey,
      authCallbackUrlHostname: config.authCallbackUrlHostname,
    );
  }

  SupabaseClient get client => Supabase.instance.client;
}
