import 'dart:typed_data';

sealed class RecordAudioEvent {}

class RecordAudioEvent_Error extends RecordAudioEvent {}

class RecordAudioEvent_Record extends RecordAudioEvent {}

class RecordAudioEvent_Pause extends RecordAudioEvent {}

class RecordAudioEvent_Resume extends RecordAudioEvent {}

class RecordAudioEvent_Stop extends RecordAudioEvent {}

class RecordAudioEvent_Save extends RecordAudioEvent {
  RecordAudioEvent_Save({
    required this.recordingName,
    required this.recordingBytes,
  });

  final String recordingName;
  final Uint8List recordingBytes;
}
