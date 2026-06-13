// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUp_State _$SignUp_StateFromJson(Map<String, dynamic> json) => SignUp_State(
  status: $enumDecode(_$SignUp_StatusEnumMap, json['status']),
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$SignUp_StateToJson(SignUp_State instance) =>
    <String, dynamic>{
      'status': _$SignUp_StatusEnumMap[instance.status]!,
      'errorMessage': instance.errorMessage,
    };

const _$SignUp_StatusEnumMap = {
  SignUp_Status.idle: 'idle',
  SignUp_Status.signUpInProgress: 'signUpInProgress',
  SignUp_Status.signUpError: 'signUpError',
  SignUp_Status.signUpSuccess: 'signUpSuccess',
  SignUp_Status.resendEmailVerificationLinkInProgress:
      'resendEmailVerificationLinkInProgress',
  SignUp_Status.resendEmailVerificationLinkError:
      'resendEmailVerificationLinkError',
  SignUp_Status.resendEmailVerificationLinkSuccess:
      'resendEmailVerificationLinkSuccess',
};
