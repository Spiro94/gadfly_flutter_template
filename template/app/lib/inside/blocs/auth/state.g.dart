// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auth_State _$Auth_StateFromJson(Map<String, dynamic> json) => Auth_State(
      status: $enumDecode(_$Auth_StatusEnumMap, json['status']),
      accessToken: json['accessToken'] as String?,
    );

Map<String, dynamic> _$Auth_StateToJson(Auth_State instance) =>
    <String, dynamic>{
      'status': _$Auth_StatusEnumMap[instance.status]!,
      'accessToken': instance.accessToken,
    };

const _$Auth_StatusEnumMap = {
  Auth_Status.unauthentcated: 'unauthentcated',
  Auth_Status.authenticated: 'authenticated',
};
