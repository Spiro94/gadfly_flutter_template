import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

@JsonSerializable()
class CustomClaimsState extends Equatable {
  const CustomClaimsState({
    required this.lastUpdatedAt,
    required this.appRoleClaim,
  });

  final DateTime? lastUpdatedAt;
  final String? appRoleClaim;

  @override
  List<Object?> get props => [
        lastUpdatedAt,
        appRoleClaim,
      ];

  // coverage:ignore-start
  factory CustomClaimsState.fromJson(Map<String, dynamic> json) =>
      _$CustomClaimsStateFromJson(json);

  Map<String, dynamic> toJson() => _$CustomClaimsStateToJson(this);
  // coverage:ignore-end
}
