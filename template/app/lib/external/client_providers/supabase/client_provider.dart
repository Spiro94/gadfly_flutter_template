import 'package:supabase_flutter/supabase_flutter.dart';

import '../base_class.dart';
import 'configuration.dart';

class SupabaseClientProvider extends Base_ClientProvider {
  SupabaseClientProvider({
    required this.configuration,
  });

  final SupabaseClientProviderConfiguration configuration;

  SupabaseClient get client => Supabase.instance.client;

  @override
  Future<void> init() async {
    log.info('init');

    await Supabase.initialize(
      url: configuration.url,
      anonKey: configuration.anonKey,
    );
  }
}
