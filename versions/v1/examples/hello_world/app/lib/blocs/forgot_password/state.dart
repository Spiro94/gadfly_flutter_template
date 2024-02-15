import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum ForgotPasswordStatus {
  idle,
  loading,

  sendLinkError,
  sendLinkSuccess,

  resendLinkError,
  resendLinkSuccess,
}

@JsonSerializable()
class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    required this.status,
    required this.forgotPasswordEmail,
  });

  final ForgotPasswordStatus status;
  final String? forgotPasswordEmail;

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
    String? Function()? setForgotPasswordEmail,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      forgotPasswordEmail:
          setForgotPasswordEmail?.call() ?? forgotPasswordEmail,
    );
  }

  @override
  List<Object?> get props => [
        status,
        forgotPasswordEmail,
      ];

  // coverage:ignore-start
  factory ForgotPasswordState.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordStateFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordStateToJson(this);
  // coverage:ignore-end
}
