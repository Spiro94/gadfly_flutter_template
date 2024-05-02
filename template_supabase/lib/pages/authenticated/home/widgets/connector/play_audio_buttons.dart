import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/recordings/bloc.dart';
import '../../../../../models/audio_recording.dart';
import 'play_audio_button.dart';

class HomeC_PlayAudioButtons extends StatelessWidget {
  const HomeC_PlayAudioButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final playAudioBloc = context.watch<RecordingsBloc>();
    final recordings =
        List<Model_AudioRecording>.from(playAudioBloc.state.recordings);
    recordings.sort((a, b) => a.recordingName.compareTo(b.recordingName));

    return Column(
      key: const Key('PlayAudioButtons'),
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final recording in recordings)
          HomeC_PlayAudioButton(
            key: Key(recording.id),
            recording: recording,
          ),
      ],
    );
  }
}
