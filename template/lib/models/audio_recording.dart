import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audio_recording.g.dart';

@JsonSerializable()
class AudioRecording extends Equatable {
  const AudioRecording({
    required this.id,
    required this.recordingName,
    required this.signedUrl,
  });

  final String id;
  final String recordingName;
  final String signedUrl;

  // coverage:ignore-start
  @override
  List<Object?> get props => [
        id,
        recordingName,
        signedUrl,
      ];

  factory AudioRecording.fromJson(Map<String, dynamic> json) =>
      _$AudioRecordingFromJson(json);

  Map<String, dynamic> toJson() => _$AudioRecordingToJson(this);
  // coverage:ignore-end
}
