import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';

import '../../../../../blocs/record_audio/bloc.dart';
import '../../../../../blocs/record_audio/event.dart';
import '../../../../../blocs/record_audio/state.dart';
import '../../../../../effects/record_audio/effect.dart';
import '../../../../../effects/record_audio/provider.dart';
import '../../../../../i18n/translations.g.dart';
import '../../../../../theme/theme.dart';

class HomeC_RecordAudioListener extends StatefulWidget {
  const HomeC_RecordAudioListener({
    required this.builder,
    super.key,
  });

  final Widget Function({
    required BuildContext context,
    required Stream<RecordState> stream,
    required bool isStarting,
  }) builder;

  @override
  State<HomeC_RecordAudioListener> createState() =>
      _HomeC_RecordAudioListenerState();
}

class _HomeC_RecordAudioListenerState extends State<HomeC_RecordAudioListener> {
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
        final sm = ScaffoldMessenger.of(context);

        switch (state.status) {
          case RecordAudioStatus.idle:
            break;
          case RecordAudioStatus.error:
            setState(() {
              _isStarting = false;
            });
            sm.hideCurrentSnackBar();
            sm.showSnackBar(
              SnackBar(
                backgroundColor: context.tokens.color.error.container,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.t.home.recordAudio.error,
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
            } catch (e) {
              _recordAudioEffect.log.warning('recording was not started');
              _recordAudioEffect.log.fine(e);
              recordAudioBloc.add(RecordAudioEvent_Error());
            }
          case RecordAudioStatus.pause:
            try {
              await _recordAudioEffect.pause();
            } catch (e) {
              _recordAudioEffect.log.warning('recording was not paused');
              _recordAudioEffect.log.fine(e);
              recordAudioBloc.add(RecordAudioEvent_Error());
            }
          case RecordAudioStatus.resume:
            try {
              await _recordAudioEffect.resume();
            } catch (e) {
              _recordAudioEffect.log.warning('recording was not resumed');
              _recordAudioEffect.log.fine(e);
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
            } catch (e) {
              _recordAudioEffect.log.warning('recording was not stopped');
              _recordAudioEffect.log.fine(e);
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
