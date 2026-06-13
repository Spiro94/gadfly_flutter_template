import 'package:supabase_flutter/supabase_flutter.dart';

import '../base.dart';
import 'effect.dart';

class AuthChange_EffectProvider extends EffectProvider_Base<AuthChange_Effect> {
  const AuthChange_EffectProvider({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  @override
  AuthChange_Effect getEffect() {
    return AuthChange_Effect(supabaseClient: _supabaseClient);
  }

  @override
  Future<void> init() async {}
}
