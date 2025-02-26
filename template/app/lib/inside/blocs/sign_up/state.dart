import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum SignUpStatus {
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
class SignUpState extends Equatable {
  const SignUpState({
    required this.status,
    required this.errorMessage,
  });

  final SignUpStatus status;
  final String? errorMessage;

  SignUpState copyWith({
    SignUpStatus? status,
    String? Function()? setErrorMessage,
  }) {
    return SignUpState(
      status: status ?? this.status,
      errorMessage: setErrorMessage != null ? setErrorMessage() : errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
      ];

  // coverage:ignore-start
  factory SignUpState.fromJson(Map<String, dynamic> json) =>
      _$SignUpStateFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpStateToJson(this);
  // coverage:ignore-end
}
