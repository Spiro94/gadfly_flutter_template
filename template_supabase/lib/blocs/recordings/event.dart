import '../../models/audio_recording.dart';

sealed class RecordingsEvent {}

class RecordingsEvent_GetMyRecordings extends RecordingsEvent {}

class RecordingsEvent_SetMyRecordings extends RecordingsEvent {
  RecordingsEvent_SetMyRecordings({
    required this.recordings,
  });

  final List<Model_AudioRecording> recordings;
}

class RecordingsEvent_PlayingError extends RecordingsEvent {}
