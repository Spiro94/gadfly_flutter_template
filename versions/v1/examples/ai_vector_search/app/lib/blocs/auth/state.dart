import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum AuthStatus {
  unauthentcated,
  authenticated,
}

@JsonSerializable()
class AuthState extends Equatable {
  const AuthState({
    required this.status,
    required this.accessToken,
  });

  final AuthStatus status;
  final String? accessToken;

  @override
  List<Object?> get props => [
        status,
        accessToken,
      ];

  // coverage:ignore-start
  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);

  Map<String, dynamic> toJson() => _$AuthStateToJson(this);
  // coverage:ignore-end
}
