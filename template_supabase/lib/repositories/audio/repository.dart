// coverage:ignore-file

import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AudioRepository {
  AudioRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  SupabaseClient get client => _supabaseClient;

  final _log = Logger('audio_repository');

  Future<void> recordingSave({
    required String recordingName,
    required Uint8List recordingBytes,
  }) async {
    _log.info('recordingSave: $recordingName');
    await _supabaseClient.storage.from('recordings').uploadBinary(
          recordingName,
          recordingBytes,
        );
  }

  Future<Stream<SupabaseStreamEvent>> getMyRecordingsStream({
    required String userId,
    SearchOptions searchOptions = const SearchOptions(),
  }) async {
    _log.info('getRecordingsStream');
    final stream = _supabaseClient
        .schema('storage')
        .from('objects')
        .stream(primaryKey: ['id']);

    return stream;
  }

  Future<List<SignedUrl>> getSignedRecordingUrls({
    required List<String> recordingNames,
  }) async {
    _log.info('getSignedRecordingUrls');
    final signedUrls =
        await _supabaseClient.storage.from('recordings').createSignedUrls(
              recordingNames,
              // expires in 1 day
              60 * 60 * 24,
            );

    return signedUrls;
  }
}
