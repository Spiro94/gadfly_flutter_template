import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum ResetPasswordStatus {
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
class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    required this.status,
    required this.errorMessage,
    required this.email,
  });

  final ResetPasswordStatus status;
  final String? errorMessage;
  final String? email;

  ResetPasswordState copyWith({
    ResetPasswordStatus? status,
    String? Function()? setErrorMessage,
    String? Function()? setEmail,
  }) {
    return ResetPasswordState(
      status: status ?? this.status,
      errorMessage: setErrorMessage != null ? setErrorMessage() : errorMessage,
      email: setEmail != null ? setEmail() : email,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        email,
      ];

  // coverage:ignore-start
  factory ResetPasswordState.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordStateFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordStateToJson(this);
  // coverage:ignore-end
}
