import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum AuthStatus {
  unauthentcated,
  authenticated,
}

enum AuthSignInStatus {
  idle,
  error,
}

@JsonSerializable()
class AuthState extends Equatable {
  const AuthState({
    required this.status,
    required this.authToken,
    required this.signInStatus,
  });

  final AuthStatus status;
  final String? authToken;
  final AuthSignInStatus signInStatus;

  /// Only use [copyWith] if changing the [signInStatus], otherwise recreate the
  /// [AuthState] from scratch.
  AuthState copyWith(AuthSignInStatus signInStatus) {
    return AuthState(
      status: status,
      authToken: authToken,
      signInStatus: signInStatus,
    );
  }

  @override
  List<Object?> get props => [
        status,
        authToken,
        signInStatus,
      ];

  // coverage:ignore-start
  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);

  Map<String, dynamic> toJson() => _$AuthStateToJson(this);
  // coverage:ignore-end
}
