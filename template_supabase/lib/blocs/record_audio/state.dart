import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum RecordAudioStatus {
  idle,
  error,
  record,
  pause,
  resume,
  stop,
}

@JsonSerializable()
class RecordAudioState extends Equatable {
  const RecordAudioState({
    required this.status,
  });

  final RecordAudioStatus status;

  @override
  List<Object?> get props => [
        status,
      ];

  // coverage:ignore-start
  factory RecordAudioState.fromJson(Map<String, dynamic> json) =>
      _$RecordAudioStateFromJson(json);

  Map<String, dynamic> toJson() => _$RecordAudioStateToJson(this);
  // coverage:ignore-end
}
