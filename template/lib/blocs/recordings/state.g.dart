// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordingsState _$RecordingsStateFromJson(Map<String, dynamic> json) =>
    RecordingsState(
      status: $enumDecode(_$RecordingsStatusEnumMap, json['status']),
      recordings: (json['recordings'] as List<dynamic>)
          .map((e) => Model_AudioRecording.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecordingsStateToJson(RecordingsState instance) =>
    <String, dynamic>{
      'status': _$RecordingsStatusEnumMap[instance.status]!,
      'recordings': instance.recordings,
    };

const _$RecordingsStatusEnumMap = {
  RecordingsStatus.idle: 'idle',
  RecordingsStatus.loading: 'loading',
  RecordingsStatus.loadingError: 'loadingError',
  RecordingsStatus.playingError: 'playingError',
};
