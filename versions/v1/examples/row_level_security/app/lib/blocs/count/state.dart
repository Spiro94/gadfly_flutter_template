import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum CountStatus {
  idle,
  loading,
  error,
}

@JsonSerializable()
class CountState extends Equatable {
  const CountState({
    required this.status,
    required this.count,
  });

  final CountStatus status;
  final int count;

  CountState copyWith({
    CountStatus? status,
    int? count,
  }) {
    return CountState(
      status: status ?? this.status,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [
        status,
        count,
      ];

  // coverage:ignore-start
  factory CountState.fromJson(Map<String, dynamic> json) =>
      _$CountStateFromJson(json);

  Map<String, dynamic> toJson() => _$CountStateToJson(this);
  // coverage:ignore-end
}
