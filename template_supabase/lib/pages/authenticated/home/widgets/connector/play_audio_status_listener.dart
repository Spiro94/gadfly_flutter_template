import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/recordings/bloc.dart';
import '../../../../../blocs/recordings/state.dart';
import '../../../../../i18n/translations.g.dart';
import '../../../../../theme/theme.dart';

class HomeC_PlayAudioStatusListener extends StatelessWidget {
  const HomeC_PlayAudioStatusListener({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordingsBloc, RecordingsState>(
      listener: (context, state) {
        final sm = ScaffoldMessenger.of(context);

        switch (state.status) {
          case RecordingsStatus.idle:
          case RecordingsStatus.loading:
            break;
          case RecordingsStatus.loadingError:
            sm.hideCurrentSnackBar();
            sm.showSnackBar(
              SnackBar(
                backgroundColor: context.tokens.color.error.container,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.t.home.getMyRecordings.error,
                      style: TextStyle(
                        color: context.tokens.color.error.onContainer,
                      ),
                    ),
                  ],
                ),
              ),
            );
          case RecordingsStatus.playingError:
            sm.hideCurrentSnackBar();
            sm.showSnackBar(
              SnackBar(
                backgroundColor: context.tokens.color.error.container,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.t.home.playRecording.error,
                      style: TextStyle(
                        color: context.tokens.color.error.onContainer,
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      },
      child: child,
    );
  }
}
