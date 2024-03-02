import 'package:supabase_client_provider/src/configuration.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientProvider {
  SupabaseClientProvider({
    required this.config,
  });

  final SupabaseClientProviderConfiguration config;

  SupabaseClient get client => Supabase.instance.client;

  Future<void> init() async {
    await Supabase.initialize(
      url: config.url,
      anonKey: config.anonKey,
    );
  }
}
