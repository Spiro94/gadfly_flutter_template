import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum SignIn_Status {
  idle,

  // signIn
  signInInProgress,
  signInError,
  signInSuccess,
}

@JsonSerializable()
class SignIn_State extends Equatable {
  const SignIn_State({required this.status, required this.errorMessage});

  final SignIn_Status status;
  final String? errorMessage;

  SignIn_State copyWith({
    SignIn_Status? status,
    String? Function()? setErrorMessage,
  }) {
    return SignIn_State(
      status: status ?? this.status,
      errorMessage: setErrorMessage != null ? setErrorMessage() : errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];

  // coverage:ignore-start
  factory SignIn_State.fromJson(Map<String, dynamic> json) =>
      _$SignIn_StateFromJson(json);

  Map<String, dynamic> toJson() => _$SignIn_StateToJson(this);
  // coverage:ignore-end
}
