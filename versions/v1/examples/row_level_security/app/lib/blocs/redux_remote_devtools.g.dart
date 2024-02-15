// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redux_remote_devtools.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevtoolsDb _$DevtoolsDbFromJson(Map<String, dynamic> json) => DevtoolsDb(
      authState: json['authState'] == null
          ? null
          : AuthState.fromJson(json['authState'] as Map<String, dynamic>),
      forgotPasswordState: json['forgotPasswordState'] == null
          ? null
          : ForgotPasswordState.fromJson(
              json['forgotPasswordState'] as Map<String, dynamic>),
      signInState: json['signInState'] == null
          ? null
          : SignInState.fromJson(json['signInState'] as Map<String, dynamic>),
      signUpState: json['signUpState'] == null
          ? null
          : SignUpState.fromJson(json['signUpState'] as Map<String, dynamic>),
      countState: json['countState'] == null
          ? null
          : CountState.fromJson(json['countState'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DevtoolsDbToJson(DevtoolsDb instance) =>
    <String, dynamic>{
      'authState': instance.authState,
      'forgotPasswordState': instance.forgotPasswordState,
      'signInState': instance.signInState,
      'signUpState': instance.signUpState,
      'countState': instance.countState,
    };
