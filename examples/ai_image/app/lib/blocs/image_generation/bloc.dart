import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import '../../repositories/image_generation/repository.dart';
import '../base_blocs.dart';
import 'event.dart';
import 'state.dart';

class ImageGenerationBloc extends ImageGenerationBaseBloc {
  ImageGenerationBloc({
    required ImageGenerationRepository imageGenerationRepository,
  })  : _imageGenerationRepository = imageGenerationRepository,
        super(
          const ImageGenerationState(
            avatarUrl: null,
            status: ImageGenerationStatus.idle,
          ),
        ) {
    on<ImageGenerationEvent_CreateAvatarImage>(
      _onCreateAvatarImage,
      transformer: sequential(),
    );
  }

  final ImageGenerationRepository _imageGenerationRepository;

  final _log = Logger('image_generation_bloc');

  Future<void> _onCreateAvatarImage(
    ImageGenerationEvent_CreateAvatarImage event,
    Emitter<ImageGenerationState> emit,
  ) async {
    emit(
      state.copyWith(status: ImageGenerationStatus.loading),
    );

    try {
      if (state.avatarUrl == null || state.avatarUrl!.isEmpty) {
        await _imageGenerationRepository.generateAvatar(
          input: event.input.trim(),
        );

        final avatarUrl = await _imageGenerationRepository.getAvatarUrl();

        emit(
          state.copyWith(avatarUrl: avatarUrl),
        );
      }
    } catch (e) {
      _log.warning(e, e is Error ? e.stackTrace : null);

      emit(
        state.copyWith(status: ImageGenerationStatus.error),
      );
    } finally {
      emit(
        state.copyWith(status: ImageGenerationStatus.idle),
      );
    }
  }
}
