// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_recording.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Model_AudioRecording _$Model_AudioRecordingFromJson(
        Map<String, dynamic> json) =>
    Model_AudioRecording(
      id: json['id'] as String,
      recordingName: json['recordingName'] as String,
      signedUrl: json['signedUrl'] as String,
    );

Map<String, dynamic> _$Model_AudioRecordingToJson(
        Model_AudioRecording instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recordingName': instance.recordingName,
      'signedUrl': instance.signedUrl,
    };
