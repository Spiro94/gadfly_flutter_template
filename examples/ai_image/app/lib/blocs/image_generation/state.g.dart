// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageGenerationState _$ImageGenerationStateFromJson(
        Map<String, dynamic> json) =>
    ImageGenerationState(
      status: $enumDecode(_$ImageGenerationStatusEnumMap, json['status']),
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$ImageGenerationStateToJson(
        ImageGenerationState instance) =>
    <String, dynamic>{
      'status': _$ImageGenerationStatusEnumMap[instance.status]!,
      'avatarUrl': instance.avatarUrl,
    };

const _$ImageGenerationStatusEnumMap = {
  ImageGenerationStatus.idle: 'idle',
  ImageGenerationStatus.loading: 'loading',
  ImageGenerationStatus.error: 'error',
};
