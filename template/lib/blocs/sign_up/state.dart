import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum SignUpStatus {
  idle,
  loading,
  error,
}

@JsonSerializable()
class SignUpState extends Equatable {
  const SignUpState({
    required this.status,
  });

  final SignUpStatus status;

  @override
  List<Object?> get props => [
        status,
      ];

  // coverage:ignore-start
  factory SignUpState.fromJson(Map<String, dynamic> json) =>
      _$SignUpStateFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpStateToJson(this);
  // coverage:ignore-end
}
