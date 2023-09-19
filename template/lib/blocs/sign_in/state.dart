import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum SignInStatus {
  idle,
  loading,
  error,
}

@JsonSerializable()
class SignInState extends Equatable {
  const SignInState({
    required this.status,
  });

  final SignInStatus status;

  @override
  List<Object?> get props => [
        status,
      ];

  // coverage:ignore-start
  factory SignInState.fromJson(Map<String, dynamic> json) =>
      _$SignInStateFromJson(json);

  Map<String, dynamic> toJson() => _$SignInStateToJson(this);
  // coverage:ignore-end
}
