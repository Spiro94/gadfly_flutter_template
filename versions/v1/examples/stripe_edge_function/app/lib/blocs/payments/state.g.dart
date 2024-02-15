// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentsState _$PaymentsStateFromJson(Map<String, dynamic> json) =>
    PaymentsState(
      status: $enumDecode(_$PaymentsStatusEnumMap, json['status']),
      accountId: json['accountId'] as String?,
    );

Map<String, dynamic> _$PaymentsStateToJson(PaymentsState instance) =>
    <String, dynamic>{
      'status': _$PaymentsStatusEnumMap[instance.status]!,
      'accountId': instance.accountId,
    };

const _$PaymentsStatusEnumMap = {
  PaymentsStatus.idle: 'idle',
  PaymentsStatus.loading: 'loading',
  PaymentsStatus.error: 'error',
};
