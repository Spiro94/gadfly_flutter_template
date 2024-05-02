import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import '../../effects/now/effect.dart';
import '../../repositories/audio/repository.dart';
import '../../repositories/auth/repository.dart';
import '../base_blocs.dart';
import 'event.dart';
import 'state.dart';

class RecordAudioBloc extends RecordAudioBaseBloc {
  RecordAudioBloc({
    required AudioRepository audioRepository,
    required AuthRepository authRepository,
    required NowEffect nowEffect,
  })  : _audioRepository = audioRepository,
        _authRepository = authRepository,
        _nowEffect = nowEffect,
        super(
          const RecordAudioState(status: RecordAudioStatus.idle),
        ) {
    on<RecordAudioEvent_Error>(
      _onError,
      transformer: sequential(),
    );
    on<RecordAudioEvent_Record>(
      _onRecord,
      transformer: sequential(),
    );
    on<RecordAudioEvent_Pause>(
      _onPause,
      transformer: sequential(),
    );
    on<RecordAudioEvent_Resume>(
      _onResume,
      transformer: sequential(),
    );
    on<RecordAudioEvent_Stop>(
      _onStop,
      transformer: sequential(),
    );
    on<RecordAudioEvent_Save>(
      _onSave,
      transformer: concurrent(),
    );
  }

  final AudioRepository _audioRepository;
  final AuthRepository _authRepository;
  final NowEffect _nowEffect;

  final _log = Logger('record_audio_bloc');

  Future<void> _onError(
    RecordAudioEvent_Error event,
    Emitter<RecordAudioState> emit,
  ) async {
    emit(const RecordAudioState(status: RecordAudioStatus.error));
    emit(const RecordAudioState(status: RecordAudioStatus.idle));
  }

  Future<void> _onRecord(
    RecordAudioEvent_Record event,
    Emitter<RecordAudioState> emit,
  ) async {
    emit(const RecordAudioState(status: RecordAudioStatus.record));
    emit(const RecordAudioState(status: RecordAudioStatus.idle));
  }

  Future<void> _onPause(
    RecordAudioEvent_Pause event,
    Emitter<RecordAudioState> emit,
  ) async {
    emit(const RecordAudioState(status: RecordAudioStatus.pause));
    emit(const RecordAudioState(status: RecordAudioStatus.idle));
  }

  Future<void> _onResume(
    RecordAudioEvent_Resume event,
    Emitter<RecordAudioState> emit,
  ) async {
    emit(const RecordAudioState(status: RecordAudioStatus.resume));
    emit(const RecordAudioState(status: RecordAudioStatus.idle));
  }

  Future<void> _onStop(
    RecordAudioEvent_Stop event,
    Emitter<RecordAudioState> emit,
  ) async {
    emit(const RecordAudioState(status: RecordAudioStatus.stop));
    emit(const RecordAudioState(status: RecordAudioStatus.idle));
  }

  Future<void> _onSave(
    RecordAudioEvent_Save event,
    Emitter<RecordAudioState> emit,
  ) async {
    try {
      final lengthInBytes = event.recordingBytes.lengthInBytes;
      if (lengthInBytes <= 4096) {
        _log.fine('length in bytes $lengthInBytes');
        throw Exception('empty recording');
      }

      final userId = await _authRepository.getUserId();

      await _audioRepository.recordingSave(
        recordingName: '$userId/${_nowEffect.now(
              debugLabel: 'RecordAudioEvent_Save',
            ).toIso8601String()}.wav',
        recordingBytes: event.recordingBytes,
      );
    } catch (e) {
      _log.warning('recording was not saved');
      _log.fine(e);
      add(RecordAudioEvent_Error());
    }
  }
}
