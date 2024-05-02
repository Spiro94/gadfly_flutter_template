// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordState _$ResetPasswordStateFromJson(Map<String, dynamic> json) =>
    ResetPasswordState(
      status: $enumDecode(_$ResetPasswordStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$ResetPasswordStateToJson(ResetPasswordState instance) =>
    <String, dynamic>{
      'status': _$ResetPasswordStatusEnumMap[instance.status]!,
    };

const _$ResetPasswordStatusEnumMap = {
  ResetPasswordStatus.idle: 'idle',
  ResetPasswordStatus.loading: 'loading',
  ResetPasswordStatus.error: 'error',
  ResetPasswordStatus.success: 'success',
};
