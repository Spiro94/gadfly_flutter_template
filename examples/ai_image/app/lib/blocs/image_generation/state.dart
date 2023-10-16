import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

enum ImageGenerationStatus {
  idle,
  loading,
  error,
}

@JsonSerializable()
class ImageGenerationState extends Equatable {
  const ImageGenerationState({
    required this.status,
    required this.avatarUrl,
  });

  final ImageGenerationStatus status;
  final String? avatarUrl;

  ImageGenerationState copyWith({
    ImageGenerationStatus? status,
    String? avatarUrl,
  }) {
    return ImageGenerationState(
      status: status ?? this.status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [
        status,
        avatarUrl,
      ];

  // coverage:ignore-start
  factory ImageGenerationState.fromJson(Map<String, dynamic> json) =>
      _$ImageGenerationStateFromJson(json);

  Map<String, dynamic> toJson() => _$ImageGenerationStateToJson(this);
  // coverage:ignore-end
}
