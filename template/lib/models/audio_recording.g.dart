// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_recording.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioRecording _$AudioRecordingFromJson(Map<String, dynamic> json) =>
    AudioRecording(
      id: json['id'] as String,
      recordingName: json['recordingName'] as String,
      signedUrl: json['signedUrl'] as String,
    );

Map<String, dynamic> _$AudioRecordingToJson(AudioRecording instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recordingName': instance.recordingName,
      'signedUrl': instance.signedUrl,
    };
