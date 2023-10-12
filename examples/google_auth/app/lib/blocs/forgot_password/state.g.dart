// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgotPasswordState _$ForgotPasswordStateFromJson(Map<String, dynamic> json) =>
    ForgotPasswordState(
      status: $enumDecode(_$ForgotPasswordStatusEnumMap, json['status']),
      forgotPasswordEmail: json['forgotPasswordEmail'] as String?,
    );

Map<String, dynamic> _$ForgotPasswordStateToJson(
        ForgotPasswordState instance) =>
    <String, dynamic>{
      'status': _$ForgotPasswordStatusEnumMap[instance.status]!,
      'forgotPasswordEmail': instance.forgotPasswordEmail,
    };

const _$ForgotPasswordStatusEnumMap = {
  ForgotPasswordStatus.idle: 'idle',
  ForgotPasswordStatus.loading: 'loading',
  ForgotPasswordStatus.sendLinkError: 'sendLinkError',
  ForgotPasswordStatus.sendLinkSuccess: 'sendLinkSuccess',
  ForgotPasswordStatus.resendLinkError: 'resendLinkError',
  ForgotPasswordStatus.resendLinkSuccess: 'resendLinkSuccess',
};
