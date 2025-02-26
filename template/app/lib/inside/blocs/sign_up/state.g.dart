// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpState _$SignUpStateFromJson(Map<String, dynamic> json) => SignUpState(
      status: $enumDecode(_$SignUpStatusEnumMap, json['status']),
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$SignUpStateToJson(SignUpState instance) =>
    <String, dynamic>{
      'status': _$SignUpStatusEnumMap[instance.status]!,
      'errorMessage': instance.errorMessage,
    };

const _$SignUpStatusEnumMap = {
  SignUpStatus.idle: 'idle',
  SignUpStatus.signUpInProgress: 'signUpInProgress',
  SignUpStatus.signUpError: 'signUpError',
  SignUpStatus.signUpSuccess: 'signUpSuccess',
  SignUpStatus.resendEmailVerificationLinkInProgress:
      'resendEmailVerificationLinkInProgress',
  SignUpStatus.resendEmailVerificationLinkError:
      'resendEmailVerificationLinkError',
  SignUpStatus.resendEmailVerificationLinkSuccess:
      'resendEmailVerificationLinkSuccess',
};
