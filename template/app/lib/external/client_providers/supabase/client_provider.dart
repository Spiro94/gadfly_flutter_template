import 'package:supabase_flutter/supabase_flutter.dart';

import '../../util/abstracts/base_provider.dart';
import 'configuration.dart';

class SupabaseClientProvider extends UtilAbstract_BaseProvider {
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
