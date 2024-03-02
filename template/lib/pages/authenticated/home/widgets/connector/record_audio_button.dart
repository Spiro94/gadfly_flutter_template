import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';

import '../../../../../blocs/record_audio/bloc.dart';
import '../../../../../blocs/record_audio/event.dart';
import '../../../../../theme/theme.dart';

class HomeC_RecordAudioButton extends StatelessWidget {
  const HomeC_RecordAudioButton({
    required this.recordAudioStream,
    required this.isStarting,
    super.key,
  });

  final Stream<RecordState> recordAudioStream;
  final bool isStarting;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: recordAudioStream,
      builder: (context, snapshot) {
        final recordState = snapshot.data;

        if (isStarting && recordState == null ||
            isStarting && recordState == RecordState.stop) {
          return CircleAvatar(
            backgroundColor: context.tokens.color.neutral.surface,
            child: IconButton(
              key: const Key('LoadingButton'),
              icon: SizedBox(
                height: context.tokens.iconSize.medium,
                width: context.tokens.iconSize.medium,
                child: CircularProgressIndicator(
                  color: context.tokens.color.neutral.onSurface,
                ),
              ),
              onPressed: null,
            ),
          );
        }

        switch (recordState) {
          case null:
          case RecordState.stop:
            return CircleAvatar(
              backgroundColor: context.tokens.color.success.container,
              child: IconButton(
                key: const Key('RecordButton'),
                icon: Icon(
                  Icons.mic,
                  size: context.tokens.iconSize.medium,
                  color: context.tokens.color.success.onContainer,
                ),
                onPressed: () {
                  context
                      .read<RecordAudioBloc>()
                      .add(RecordAudioEvent_Record());
                },
              ),
            );
          case RecordState.record:
            return Row(
              children: [
                CircleAvatar(
                  backgroundColor: context.tokens.color.info.container,
                  child: IconButton(
                    key: const Key('PauseButton'),
                    icon: Icon(
                      Icons.pause,
                      size: context.tokens.iconSize.medium,
                      color: context.tokens.color.info.onContainer,
                    ),
                    onPressed: () {
                      context
                          .read<RecordAudioBloc>()
                          .add(RecordAudioEvent_Pause());
                    },
                  ),
                ),
                SizedBox(width: context.tokens.spacing.small),
                CircleAvatar(
                  backgroundColor: context.tokens.color.error.container,
                  child: IconButton(
                    key: const Key('StopButton'),
                    icon: Icon(
                      Icons.stop,
                      size: context.tokens.iconSize.medium,
                      color: context.tokens.color.error.onContainer,
                    ),
                    onPressed: () {
                      context
                          .read<RecordAudioBloc>()
                          .add(RecordAudioEvent_Stop());
                    },
                  ),
                ),
              ],
            );
          case RecordState.pause:
            return CircleAvatar(
              backgroundColor: context.tokens.color.info.container,
              child: IconButton(
                key: const Key('ResumeButton'),
                icon: Icon(
                  Icons.mic,
                  size: context.tokens.iconSize.medium,
                  color: context.tokens.color.info.onContainer,
                ),
                onPressed: () {
                  context
                      .read<RecordAudioBloc>()
                      .add(RecordAudioEvent_Resume());
                },
              ),
            );
        }
      },
    );
  }
}
