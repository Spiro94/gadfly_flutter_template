import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum SignInStatus {
  idle,

  // signIn
  signInInProgress,
  signInError,
  signInSuccess,
}

@JsonSerializable()
class SignInState extends Equatable {
  const SignInState({
    required this.status,
    required this.errorMessage,
  });

  final SignInStatus status;
  final String? errorMessage;

  SignInState copyWith({
    SignInStatus? status,
    String? Function()? setErrorMessage,
  }) {
    return SignInState(
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
  factory SignInState.fromJson(Map<String, dynamic> json) =>
      _$SignInStateFromJson(json);

  Map<String, dynamic> toJson() => _$SignInStateToJson(this);
  // coverage:ignore-end
}
