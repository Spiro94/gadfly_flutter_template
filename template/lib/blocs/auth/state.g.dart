// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthState _$AuthStateFromJson(Map<String, dynamic> json) => AuthState(
      status: $enumDecode(_$AuthStatusEnumMap, json['status']),
      authToken: json['authToken'] as String?,
      signInStatus:
          $enumDecode(_$AuthSignInStatusEnumMap, json['signInStatus']),
    );

Map<String, dynamic> _$AuthStateToJson(AuthState instance) => <String, dynamic>{
      'status': _$AuthStatusEnumMap[instance.status]!,
      'authToken': instance.authToken,
      'signInStatus': _$AuthSignInStatusEnumMap[instance.signInStatus]!,
    };

const _$AuthStatusEnumMap = {
  AuthStatus.unauthentcated: 'unauthentcated',
  AuthStatus.authenticated: 'authenticated',
};

const _$AuthSignInStatusEnumMap = {
  AuthSignInStatus.idle: 'idle',
  AuthSignInStatus.error: 'error',
};
