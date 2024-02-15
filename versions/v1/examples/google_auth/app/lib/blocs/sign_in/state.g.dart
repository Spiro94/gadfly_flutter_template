// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInState _$SignInStateFromJson(Map<String, dynamic> json) => SignInState(
      status: $enumDecode(_$SignInStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$SignInStateToJson(SignInState instance) =>
    <String, dynamic>{
      'status': _$SignInStatusEnumMap[instance.status]!,
    };

const _$SignInStatusEnumMap = {
  SignInStatus.idle: 'idle',
  SignInStatus.loading: 'loading',
  SignInStatus.error: 'error',
};
