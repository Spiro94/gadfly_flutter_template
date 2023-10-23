// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchState _$SearchStateFromJson(Map<String, dynamic> json) => SearchState(
      status: $enumDecode(_$SearchStatusEnumMap, json['status']),
      markdownResponse: json['markdownResponse'] as String?,
    );

Map<String, dynamic> _$SearchStateToJson(SearchState instance) =>
    <String, dynamic>{
      'status': _$SearchStatusEnumMap[instance.status]!,
      'markdownResponse': instance.markdownResponse,
    };

const _$SearchStatusEnumMap = {
  SearchStatus.idle: 'idle',
  SearchStatus.loading: 'loading',
  SearchStatus.error: 'error',
};
