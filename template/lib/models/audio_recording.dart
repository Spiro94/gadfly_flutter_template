import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audio_recording.g.dart';

@JsonSerializable()
class Model_AudioRecording extends Equatable {
  const Model_AudioRecording({
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

  factory Model_AudioRecording.fromJson(Map<String, dynamic> json) =>
      _$Model_AudioRecordingFromJson(json);

  Map<String, dynamic> toJson() => _$Model_AudioRecordingToJson(this);
  // coverage:ignore-end
}
