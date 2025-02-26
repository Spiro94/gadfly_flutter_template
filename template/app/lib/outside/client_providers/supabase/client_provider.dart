import 'package:supabase_flutter/supabase_flutter.dart';

import '../base.dart';
import 'client_provider_configuration.dart';

class Supabase_ClientProvider extends ClientProvider_Base {
  Supabase_ClientProvider({
    required this.configuration,
  });

  final Supabase_ClientProvider_Configuration configuration;

  SupabaseClient get client => Supabase.instance.client;

  @override
  Future<void> init() async {
    await Supabase.initialize(
      url: configuration.url,
      anonKey: configuration.anonKey,
      debug: false,
    );
  }
}
