import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum PaymentsStatus {
  idle,
  loading,
  error,
}

@JsonSerializable()
class PaymentsState extends Equatable {
  const PaymentsState({
    required this.status,
    required this.accountId,
  });

  final PaymentsStatus status;
  final String? accountId;

  PaymentsState copyWith({
    PaymentsStatus? status,
    String? accountId,
  }) {
    return PaymentsState(
      status: status ?? this.status,
      accountId: accountId ?? this.accountId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        accountId,
      ];

  // coverage:ignore-start
  factory PaymentsState.fromJson(Map<String, dynamic> json) =>
      _$PaymentsStateFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentsStateToJson(this);
  // coverage:ignore-end
}
