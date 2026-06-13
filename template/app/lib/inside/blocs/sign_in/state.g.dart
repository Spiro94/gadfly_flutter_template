// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignIn_State _$SignIn_StateFromJson(Map<String, dynamic> json) => SignIn_State(
  status: $enumDecode(_$SignIn_StatusEnumMap, json['status']),
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$SignIn_StateToJson(SignIn_State instance) =>
    <String, dynamic>{
      'status': _$SignIn_StatusEnumMap[instance.status]!,
      'errorMessage': instance.errorMessage,
    };

const _$SignIn_StatusEnumMap = {
  SignIn_Status.idle: 'idle',
  SignIn_Status.signInInProgress: 'signInInProgress',
  SignIn_Status.signInError: 'signInError',
  SignIn_Status.signInSuccess: 'signInSuccess',
};
