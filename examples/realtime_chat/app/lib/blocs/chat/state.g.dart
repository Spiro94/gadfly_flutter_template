// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatState _$ChatStateFromJson(Map<String, dynamic> json) => ChatState(
      status: $enumDecode(_$ChatStatusEnumMap, json['status']),
      messages:
          (json['messages'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ChatStateToJson(ChatState instance) => <String, dynamic>{
      'status': _$ChatStatusEnumMap[instance.status]!,
      'messages': instance.messages,
    };

const _$ChatStatusEnumMap = {
  ChatStatus.idle: 'idle',
  ChatStatus.loading: 'loading',
  ChatStatus.error: 'error',
};
