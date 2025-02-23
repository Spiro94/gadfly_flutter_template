// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bloc_event_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BDEBlocEventPayload _$BDEBlocEventPayloadFromJson(Map<String, dynamic> json) =>
    BDEBlocEventPayload(
      blocName: json['bloc_name'] as String,
      blocState:
          BDEBlocEventPayload._blocStateFromJson(json['bloc_state'] as String?),
      eventName: json['event_name'] as String,
      logs: BDEBlocEventPayload._logsFromJson(json['logs'] as String),
    );

Map<String, dynamic> _$BDEBlocEventPayloadToJson(
        BDEBlocEventPayload instance) =>
    <String, dynamic>{
      'bloc_name': instance.blocName,
      'bloc_state': instance.blocState,
      'event_name': instance.eventName,
      'logs': instance.logs,
    };
