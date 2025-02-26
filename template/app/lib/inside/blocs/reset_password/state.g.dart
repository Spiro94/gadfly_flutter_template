// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordState _$ResetPasswordStateFromJson(Map<String, dynamic> json) =>
    ResetPasswordState(
      status: $enumDecode(_$ResetPasswordStatusEnumMap, json['status']),
      errorMessage: json['errorMessage'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$ResetPasswordStateToJson(ResetPasswordState instance) =>
    <String, dynamic>{
      'status': _$ResetPasswordStatusEnumMap[instance.status]!,
      'errorMessage': instance.errorMessage,
      'email': instance.email,
    };

const _$ResetPasswordStatusEnumMap = {
  ResetPasswordStatus.idle: 'idle',
  ResetPasswordStatus.sendResetPasswordLinkInProgress:
      'sendResetPasswordLinkInProgress',
  ResetPasswordStatus.sendResetPasswordLinkError: 'sendResetPasswordLinkError',
  ResetPasswordStatus.sendResetPasswordLinkSuccess:
      'sendResetPasswordLinkSuccess',
  ResetPasswordStatus.resendResetPasswordLinkInProgress:
      'resendResetPasswordLinkInProgress',
  ResetPasswordStatus.resendResetPasswordLinkError:
      'resendResetPasswordLinkError',
  ResetPasswordStatus.resendResetPasswordLinkSuccess:
      'resendResetPasswordLinkSuccess',
  ResetPasswordStatus.resetPasswordInProgress: 'resetPasswordInProgress',
  ResetPasswordStatus.resetPasswordError: 'resetPasswordError',
  ResetPasswordStatus.resetPasswordSuccess: 'resetPasswordSuccess',
};
