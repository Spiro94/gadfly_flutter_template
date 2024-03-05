import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../../blocs/recordings/bloc.dart';
import '../../../../../blocs/recordings/event.dart';
import '../../../../../effects/play_audio/effect.dart';
import '../../../../../effects/play_audio/provider.dart';
import '../../../../../models/audio_recording.dart';
import '../../../../../theme/theme.dart';

class HomeC_PlayAudioButton extends StatefulWidget {
  const HomeC_PlayAudioButton({
    required this.recording,
    super.key,
  });

  final AudioRecording recording;

  @override
  State<HomeC_PlayAudioButton> createState() => _HomeC_PlayAudioButtonState();
}

class _HomeC_PlayAudioButtonState extends State<HomeC_PlayAudioButton> {
  late PlayAudioEffect playAudioEffect;

  @override
  void initState() {
    super.initState();
    playAudioEffect = context.read<PlayAudioEffectProvider>().getEffect(
          debugLabel: widget.recording.id,
        );
  }

  @override
  void dispose() {
    playAudioEffect.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: playAudioEffect.playerStateStream(),
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;

        if (snapshot.connectionState == ConnectionState.waiting ||
            processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return ListTile(
            key: const Key('loading'),
            title: Text(widget.recording.recordingName),
            leading: SizedBox(
              width: context.tokens.iconSize.small,
              height: context.tokens.iconSize.small,
              child: SpinKitCircle(
                size: context.tokens.iconSize.small,
                color: context.tokens.color.neutral.outline,
              ),
            ),
            onTap: null,
          );
        } else if (playing != true) {
          return ListTile(
            key: const Key('resume'),
            title: Text(widget.recording.recordingName),
            leading: const Icon(Icons.play_circle),
            onTap: () async {
              try {
                if (playAudioEffect.playerUrl == null) {
                  await playAudioEffect.setUrl(url: widget.recording.signedUrl);
                }
                await playAudioEffect.play();
              } catch (e) {
                playAudioEffect.log.warning('could not play');
                playAudioEffect.log.fine(e);
                if (!context.mounted) return;
                context
                    .read<RecordingsBloc>()
                    .add(RecordingsEvent_PlayingError());
              }
            },
          );
        } else if (processingState != ProcessingState.completed) {
          return ListTile(
            key: const Key('pause'),
            title: Text(widget.recording.recordingName),
            leading: const Icon(Icons.pause_circle),
            onTap: () {
              try {
                playAudioEffect.pause();
              } catch (e) {
                playAudioEffect.log.warning('could not pause');
                playAudioEffect.log.fine(e);
                if (!context.mounted) return;
                context
                    .read<RecordingsBloc>()
                    .add(RecordingsEvent_PlayingError());
              }
            },
          );
        } else {
          return ListTile(
            key: const Key('replay'),
            title: Text(widget.recording.recordingName),
            leading: const Icon(Icons.replay_circle_filled),
            onTap: () {
              try {
                playAudioEffect.replay();
              } catch (e) {
                playAudioEffect.log.warning('could not replay');
                playAudioEffect.log.fine(e);
                if (!context.mounted) return;
                context
                    .read<RecordingsBloc>()
                    .add(RecordingsEvent_PlayingError());
              }
            },
          );
        }
      },
    );
  }
}
