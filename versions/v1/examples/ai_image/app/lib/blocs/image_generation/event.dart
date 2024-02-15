sealed class ImageGenerationEvent {}

class ImageGenerationEvent_CreateAvatarImage extends ImageGenerationEvent {
  ImageGenerationEvent_CreateAvatarImage({
    required this.input,
  });

  final String input;
}
