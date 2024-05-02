import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import '../../effects/uuid/effect.dart';
import '../../effects/uuid/provider.dart';
import '../../models/audio_recording.dart';
import '../../repositories/audio/repository.dart';
import '../../repositories/auth/repository.dart';
import '../base_blocs.dart';
import 'event.dart';
import 'state.dart';

class RecordingsBloc extends RecordingsBaseBloc {
  RecordingsBloc({
    required AudioRepository audioRepository,
    required AuthRepository authRepository,
    required UuidEffectProvider uuidEffectProvider,
  })  : _audioRepository = audioRepository,
        _authRepository = authRepository,
        _uuidEffect = uuidEffectProvider.getEffect(),
        super(
          const RecordingsState(
            status: RecordingsStatus.idle,
            recordings: [],
          ),
        ) {
    on<RecordingsEvent_GetMyRecordings>(
      _onGetMyRecordings,
      transformer: sequential(),
    );
    on<RecordingsEvent_SetMyRecordings>(
      _onSetMyRecordings,
      transformer: sequential(),
    );
    on<RecordingsEvent_PlayingError>(
      _onPlayingError,
      transformer: sequential(),
    );
  }

  final AudioRepository _audioRepository;
  final AuthRepository _authRepository;
  final UuidEffect _uuidEffect;

  final _log = Logger('recordings_bloc');

  static StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }

  Future<void> _onGetMyRecordings(
    RecordingsEvent_GetMyRecordings event,
    Emitter<RecordingsState> emit,
  ) async {
    try {
      final userId = await _authRepository.getUserId();

      final stream =
          await _audioRepository.getMyRecordingsStream(userId: userId);

      _subscription = stream.listen((rows) async {
        final recordings = List<Model_AudioRecording>.from(state.recordings);

        // If subscription hasn't been initialized, or if there are no rows,
        // exit early and emit no recordings.
        if (_subscription == null || rows.isEmpty) {
          add(RecordingsEvent_SetMyRecordings(recordings: []));
          return;
        }

        // Get the recording paths from the `path_tokens` which is a column in
        // Supabase's storage.objects table.
        final recordingPaths = rows.map((row) {
          final path_tokens = row['path_tokens'] as List<dynamic>;
          return path_tokens.join('/');
        }).toList();

        final recordingNames =
            recordingPaths.map((rp) => rp.split('/').last).toList();

        // remove recordings in the Bloc's state that no longer exist in the
        // current recordingNames.
        recordings
            .removeWhere((r) => !recordingNames.contains(r.recordingName));

        // Get signed urls for each recording path
        final signedUrls = await _audioRepository.getSignedRecordingUrls(
          recordingNames: recordingPaths,
        );

        for (final rp in recordingPaths) {
          final recordingName = rp.split('/').last;

          // If the recording already exists, then assume it already has a
          // signed url and id, so we can exit early.
          if (recordings.any(
            (recording) => recording.recordingName == recordingName,
          )) {
            continue;
          }

          final signedUrl = signedUrls.firstWhereOrNull((s) => s.path == rp);

          if (signedUrl != null) {
            recordings.add(
              Model_AudioRecording(
                id: _uuidEffect.generateUuidV4(debugLabel: recordingName),
                recordingName: recordingName,
                signedUrl: signedUrl.signedUrl,
              ),
            );
          }
        }

        add(RecordingsEvent_SetMyRecordings(recordings: recordings));
      });
    } catch (e) {
      _log.warning('recordings were not fetched');
      _log.fine(e);
      emit(state.copyWith(status: RecordingsStatus.loadingError));
    } finally {
      emit(state.copyWith(status: RecordingsStatus.idle));
    }
  }

  Future<void> _onSetMyRecordings(
    RecordingsEvent_SetMyRecordings event,
    Emitter<RecordingsState> emit,
  ) async {
    emit(state.copyWith(recordings: event.recordings));
  }

  Future<void> _onPlayingError(
    RecordingsEvent_PlayingError event,
    Emitter<RecordingsState> emit,
  ) async {
    emit(state.copyWith(status: RecordingsStatus.playingError));
    emit(state.copyWith(status: RecordingsStatus.idle));
  }
}
