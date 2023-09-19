// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthState _$AuthStateFromJson(Map<String, dynamic> json) => AuthState(
      status: $enumDecode(_$AuthStatusEnumMap, json['status']),
      accessToken: json['accessToken'] as String?,
    );

Map<String, dynamic> _$AuthStateToJson(AuthState instance) => <String, dynamic>{
      'status': _$AuthStatusEnumMap[instance.status]!,
      'accessToken': instance.accessToken,
    };

const _$AuthStatusEnumMap = {
  AuthStatus.unauthentcated: 'unauthentcated',
  AuthStatus.authenticated: 'authenticated',
};
