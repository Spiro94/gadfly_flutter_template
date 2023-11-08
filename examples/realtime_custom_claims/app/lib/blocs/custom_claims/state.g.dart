// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomClaimsState _$CustomClaimsStateFromJson(Map<String, dynamic> json) =>
    CustomClaimsState(
      lastUpdatedAt: json['lastUpdatedAt'] == null
          ? null
          : DateTime.parse(json['lastUpdatedAt'] as String),
      appRoleClaim: json['appRoleClaim'] as String?,
    );

Map<String, dynamic> _$CustomClaimsStateToJson(CustomClaimsState instance) =>
    <String, dynamic>{
      'lastUpdatedAt': instance.lastUpdatedAt?.toIso8601String(),
      'appRoleClaim': instance.appRoleClaim,
    };
