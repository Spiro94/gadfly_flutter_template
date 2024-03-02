import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/recordings/bloc.dart';
import '../../../blocs/recordings/event.dart';
import '../../../shared/widgets/connector/record_audio_listener.dart';
import '../../../theme/theme.dart';
import 'widgets/connector/app_bar.dart';
import 'widgets/connector/play_audio_buttons.dart';
import 'widgets/connector/play_audio_status_listener.dart';
import 'widgets/connector/record_audio_button.dart';

@RoutePage()
class Home_Page extends StatefulWidget {
  const Home_Page({
    super.key,
  });

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  @override
  void initState() {
    super.initState();
    context.read<RecordingsBloc>().add(RecordingsEvent_GetMyRecordings());
  }

  @override
  Widget build(BuildContext context) {
    return const Home_Scaffold();
  }
}

class Home_Scaffold extends StatelessWidget {
  const Home_Scaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeC_AppBar(),
      body: HomeC_PlayAudioStatusListener(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(context.tokens.spacing.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SharedC_RecordAudioListener(
                  builder: ({
                    required context,
                    required stream,
                    required isStarting,
                  }) =>
                      HomeC_RecordAudioButton(
                    recordAudioStream: stream,
                    isStarting: isStarting,
                  ),
                ),
                SizedBox(
                  height: context.tokens.spacing.medium,
                ),
                const HomeC_PlayAudioButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
