import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum Auth_Status {
  unauthentcated,
  authenticated,
}

@JsonSerializable()
class Auth_State extends Equatable {
  const Auth_State({
    required this.status,
    required this.accessToken,
  });

  final Auth_Status status;
  final String? accessToken;

  @override
  List<Object?> get props => [
        status,
        accessToken,
      ];

  // coverage:ignore-start
  factory Auth_State.fromJson(Map<String, dynamic> json) =>
      _$Auth_StateFromJson(json);

  Map<String, dynamic> toJson() => _$Auth_StateToJson(this);
  // coverage:ignore-end
}
