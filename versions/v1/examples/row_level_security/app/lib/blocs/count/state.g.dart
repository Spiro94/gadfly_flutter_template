// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountState _$CountStateFromJson(Map<String, dynamic> json) => CountState(
      status: $enumDecode(_$CountStatusEnumMap, json['status']),
      count: json['count'] as int,
    );

Map<String, dynamic> _$CountStateToJson(CountState instance) =>
    <String, dynamic>{
      'status': _$CountStatusEnumMap[instance.status]!,
      'count': instance.count,
    };

const _$CountStatusEnumMap = {
  CountStatus.idle: 'idle',
  CountStatus.loading: 'loading',
  CountStatus.error: 'error',
};
