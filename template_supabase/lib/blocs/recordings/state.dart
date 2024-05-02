import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../models/audio_recording.dart';

part 'state.g.dart';

enum RecordingsStatus {
  idle,
  loading,
  loadingError,
  playingError,
}

@JsonSerializable()
class RecordingsState extends Equatable {
  const RecordingsState({
    required this.status,
    required this.recordings,
  });

  final RecordingsStatus status;
  final List<Model_AudioRecording> recordings;

  RecordingsState copyWith({
    RecordingsStatus? status,
    List<Model_AudioRecording>? recordings,
  }) {
    return RecordingsState(
      status: status ?? this.status,
      recordings: recordings ?? this.recordings,
    );
  }

  @override
  List<Object?> get props => [
        status,
        recordings,
      ];

  // coverage:ignore-start
  factory RecordingsState.fromJson(Map<String, dynamic> json) =>
      _$RecordingsStateFromJson(json);

  Map<String, dynamic> toJson() => _$RecordingsStateToJson(this);
  // coverage:ignore-end
}
