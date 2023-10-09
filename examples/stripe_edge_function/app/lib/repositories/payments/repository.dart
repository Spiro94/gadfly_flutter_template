import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentsRepository {
  PaymentsRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  final _log = Logger('payment_repository');

  Future<String?> getAccountId() async {
    _log.info('getAccountId');

    final response = await _supabaseClient
        .from('profiles')
        .select<Map<String, dynamic>>('stripe_id')
        .single();

    return response['stripe_id'] as String?;
  }

  Future<String> createStripeAccount() async {
    _log.info('createStripeAccount');

    final response = await _supabaseClient.functions.invoke(
      'create_stripe_account',
    );

    return (response.data as Map<String, dynamic>)['stripe_id'] as String;
  }
}
