import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';

import '../../../blocs/record_audio/bloc.dart';
import '../../../blocs/record_audio/event.dart';
import '../../../blocs/record_audio/state.dart';
import '../../../effects/record_audio/effect.dart';
import '../../../effects/record_audio/provider.dart';
import '../../../i18n/translations.g.dart';
import '../../../theme/theme.dart';

class SharedC_RecordAudioListener extends StatefulWidget {
  const SharedC_RecordAudioListener({
    required this.builder,
    super.key,
  });

  final Widget Function({
    required BuildContext context,
    required Stream<RecordState> stream,
    required bool isStarting,
  }) builder;

  @override
  State<SharedC_RecordAudioListener> createState() =>
      _SharedC_RecordAudioListenerState();
}

class _SharedC_RecordAudioListenerState
    extends State<SharedC_RecordAudioListener> {
  late RecordAudioEffect _recordAudioEffect;

  bool _isStarting = false;

  @override
  void initState() {
    super.initState();
    _recordAudioEffect = context.read<RecordAudioEffectProvider>().getEffect();
  }

  @override
  void dispose() {
    _recordAudioEffect.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordAudioBloc, RecordAudioState>(
      listener: (context, state) async {
        final recordAudioBloc = context.read<RecordAudioBloc>();

        switch (state.status) {
          case RecordAudioStatus.idle:
            break;
          case RecordAudioStatus.error:
            setState(() {
              _isStarting = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: context.tokens.color.error.container,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.t.shared.recordAudio.error,
                      style: TextStyle(
                        color: context.tokens.color.error.onContainer,
                      ),
                    ),
                  ],
                ),
              ),
            );
          case RecordAudioStatus.record:
            try {
              setState(() {
                _isStarting = true;
              });
              await _recordAudioEffect.start();
            } catch (_) {
              _recordAudioEffect.log.warning('recording was not started');
              recordAudioBloc.add(RecordAudioEvent_Error());
            }
          case RecordAudioStatus.pause:
            try {
              await _recordAudioEffect.pause();
            } catch (_) {
              _recordAudioEffect.log.warning('recording was not paused');
              recordAudioBloc.add(RecordAudioEvent_Error());
            }
          case RecordAudioStatus.resume:
            try {
              await _recordAudioEffect.resume();
            } catch (_) {
              _recordAudioEffect.log.warning('recording was not resumed');
              recordAudioBloc.add(RecordAudioEvent_Error());
            }

          case RecordAudioStatus.stop:
            try {
              setState(() {
                _isStarting = false;
              });
              final recordingPath = await _recordAudioEffect.stop();

              // If there is a recording, then save it
              final recordingBytes = await _recordAudioEffect.getFileBytes(
                recordingPath: recordingPath!,
              );
              recordAudioBloc.add(
                RecordAudioEvent_Save(
                  recordingBytes: recordingBytes,
                ),
              );
            } catch (_) {
              _recordAudioEffect.log.warning('recording was not stopped');
              recordAudioBloc.add(RecordAudioEvent_Error());
            }
        }
      },
      child: widget.builder(
        context: context,
        stream: _recordAudioEffect.onStateChangedStream(),
        isStarting: _isStarting,
      ),
    );
  }
}
