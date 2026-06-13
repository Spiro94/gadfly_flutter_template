// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPassword_State _$ResetPassword_StateFromJson(Map<String, dynamic> json) =>
    ResetPassword_State(
      status: $enumDecode(_$ResetPassword_StatusEnumMap, json['status']),
      errorMessage: json['errorMessage'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$ResetPassword_StateToJson(
  ResetPassword_State instance,
) => <String, dynamic>{
  'status': _$ResetPassword_StatusEnumMap[instance.status]!,
  'errorMessage': instance.errorMessage,
  'email': instance.email,
};

const _$ResetPassword_StatusEnumMap = {
  ResetPassword_Status.idle: 'idle',
  ResetPassword_Status.sendResetPasswordLinkInProgress:
      'sendResetPasswordLinkInProgress',
  ResetPassword_Status.sendResetPasswordLinkError: 'sendResetPasswordLinkError',
  ResetPassword_Status.sendResetPasswordLinkSuccess:
      'sendResetPasswordLinkSuccess',
  ResetPassword_Status.resendResetPasswordLinkInProgress:
      'resendResetPasswordLinkInProgress',
  ResetPassword_Status.resendResetPasswordLinkError:
      'resendResetPasswordLinkError',
  ResetPassword_Status.resendResetPasswordLinkSuccess:
      'resendResetPasswordLinkSuccess',
  ResetPassword_Status.resetPasswordInProgress: 'resetPasswordInProgress',
  ResetPassword_Status.resetPasswordError: 'resetPasswordError',
  ResetPassword_Status.resetPasswordSuccess: 'resetPasswordSuccess',
};
