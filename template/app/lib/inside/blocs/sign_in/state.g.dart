// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInState _$SignInStateFromJson(Map<String, dynamic> json) => SignInState(
      status: $enumDecode(_$SignInStatusEnumMap, json['status']),
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$SignInStateToJson(SignInState instance) =>
    <String, dynamic>{
      'status': _$SignInStatusEnumMap[instance.status]!,
      'errorMessage': instance.errorMessage,
    };

const _$SignInStatusEnumMap = {
  SignInStatus.idle: 'idle',
  SignInStatus.signInInProgress: 'signInInProgress',
  SignInStatus.signInError: 'signInError',
  SignInStatus.signInSuccess: 'signInSuccess',
};
