import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum ResetPassword_Status {
  idle,

  // sendResetPasswordLink
  sendResetPasswordLinkInProgress,
  sendResetPasswordLinkError,
  sendResetPasswordLinkSuccess,

  // resendResetPasswordLink
  resendResetPasswordLinkInProgress,
  resendResetPasswordLinkError,
  resendResetPasswordLinkSuccess,

  // resetPassword
  resetPasswordInProgress,
  resetPasswordError,
  resetPasswordSuccess,
}

@JsonSerializable()
class ResetPassword_State extends Equatable {
  const ResetPassword_State({
    required this.status,
    required this.errorMessage,
    required this.email,
  });

  final ResetPassword_Status status;
  final String? errorMessage;
  final String? email;

  ResetPassword_State copyWith({
    ResetPassword_Status? status,
    String? Function()? setErrorMessage,
    String? Function()? setEmail,
  }) {
    return ResetPassword_State(
      status: status ?? this.status,
      errorMessage: setErrorMessage != null ? setErrorMessage() : errorMessage,
      email: setEmail != null ? setEmail() : email,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, email];

  // coverage:ignore-start
  factory ResetPassword_State.fromJson(Map<String, dynamic> json) =>
      _$ResetPassword_StateFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPassword_StateToJson(this);
  // coverage:ignore-end
}
