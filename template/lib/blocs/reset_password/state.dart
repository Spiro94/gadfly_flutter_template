import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum ResetPasswordStatus {
  idle,
  loading,
  error,
  success,
}

@JsonSerializable()
class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    required this.status,
  });

  final ResetPasswordStatus status;

  @override
  List<Object?> get props => [
        status,
      ];

  // coverage:ignore-start
  factory ResetPasswordState.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordStateFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordStateToJson(this);
  // coverage:ignore-end
}
