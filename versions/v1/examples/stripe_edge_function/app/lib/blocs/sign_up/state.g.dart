// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpState _$SignUpStateFromJson(Map<String, dynamic> json) => SignUpState(
      status: $enumDecode(_$SignUpStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$SignUpStateToJson(SignUpState instance) =>
    <String, dynamic>{
      'status': _$SignUpStatusEnumMap[instance.status]!,
    };

const _$SignUpStatusEnumMap = {
  SignUpStatus.idle: 'idle',
  SignUpStatus.loading: 'loading',
  SignUpStatus.error: 'error',
};
