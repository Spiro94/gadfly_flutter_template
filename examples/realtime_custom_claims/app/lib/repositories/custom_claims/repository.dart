import 'package:logging/logging.dart';
// ignore: depend_on_referenced_packages,implementation_imports
import 'package:supabase/src/supabase_stream_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomClaimsRepository {
  CustomClaimsRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  final _log = Logger('custom_claims_repository');

  Future<Stream<SupabaseStreamEvent>> getCustomClaimUpdatesStream() async {
    _log.info('subscribeToCustomClaimUpdates');

    final stream =
        _supabaseClient.from('custom_claim_updates').stream(primaryKey: ['id']);

    return stream;
  }

  Future<void> refreshAuthSession() async {
    _log.info('refreshAuthSession');
    await _supabaseClient.auth.refreshSession();
  }

  Future<Map<String, dynamic>> getMyClaims() async {
    _log.info('getMyClaims');
    return await _supabaseClient.rpc('get_my_claims') as Map<String, dynamic>;
  }
}
