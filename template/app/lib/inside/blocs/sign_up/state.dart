import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum SignUp_Status {
  idle,

  // signUp
  signUpInProgress,
  signUpError,
  signUpSuccess,

  // resendEmailVerificationLink
  resendEmailVerificationLinkInProgress,
  resendEmailVerificationLinkError,
  resendEmailVerificationLinkSuccess,
}

@JsonSerializable()
class SignUp_State extends Equatable {
  const SignUp_State({required this.status, required this.errorMessage});

  final SignUp_Status status;
  final String? errorMessage;

  SignUp_State copyWith({
    SignUp_Status? status,
    String? Function()? setErrorMessage,
  }) {
    return SignUp_State(
      status: status ?? this.status,
      errorMessage: setErrorMessage != null ? setErrorMessage() : errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];

  // coverage:ignore-start
  factory SignUp_State.fromJson(Map<String, dynamic> json) =>
      _$SignUp_StateFromJson(json);

  Map<String, dynamic> toJson() => _$SignUp_StateToJson(this);
  // coverage:ignore-end
}
