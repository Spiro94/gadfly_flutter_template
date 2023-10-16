import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageGenerationRepository {
  ImageGenerationRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  final _log = Logger('image_generation_repository');

  Future<void> generateAvatar({
    required String input,
  }) async {
    _log.info('generateAvatar');

    await _supabaseClient.functions.invoke(
      'hugging_face_image_generation',
      body: {
        'input': input,
      },
    );
  }

  Future<String> getAvatarUrl() {
    _log.info('getAvatarUrl');

    return _supabaseClient.storage.from('images').createSignedUrl(
          '/${_supabaseClient.auth.currentSession!.user.id}/avatar',
          60 * 5,
        );
  }
}
