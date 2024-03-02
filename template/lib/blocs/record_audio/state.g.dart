// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordAudioState _$RecordAudioStateFromJson(Map<String, dynamic> json) =>
    RecordAudioState(
      status: $enumDecode(_$RecordAudioStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$RecordAudioStateToJson(RecordAudioState instance) =>
    <String, dynamic>{
      'status': _$RecordAudioStatusEnumMap[instance.status]!,
    };

const _$RecordAudioStatusEnumMap = {
  RecordAudioStatus.idle: 'idle',
  RecordAudioStatus.error: 'error',
  RecordAudioStatus.record: 'record',
  RecordAudioStatus.pause: 'pause',
  RecordAudioStatus.resume: 'resume',
  RecordAudioStatus.stop: 'stop',
};
