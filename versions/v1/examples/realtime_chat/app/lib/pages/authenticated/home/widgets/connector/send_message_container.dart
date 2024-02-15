import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/theme/theme.dart';
import '../../../../../blocs/chat/bloc.dart';
import '../../../../../blocs/chat/event.dart';
import '../../../../../blocs/chat/state.dart';
import '../../../../../i18n/translations.g.dart';
import '../../../../../shared/widgets/dumb/button.dart';

class HomeC_SendMessageContainer extends StatefulWidget {
  const HomeC_SendMessageContainer({super.key});

  @override
  State<HomeC_SendMessageContainer> createState() =>
      _HomeC_SendMessageContainerState();
}

class _HomeC_SendMessageContainerState
    extends State<HomeC_SendMessageContainer> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onSumbit(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();
    chatBloc.add(ChatEvent_SendMessage(message: controller.text));
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.watch<ChatBloc>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(context.spacings.medium),
            child: TextFormField(
              controller: controller,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _onSumbit(context),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(context.spacings.medium),
          child: SharedD_Button(
            label: context.t.home.send,
            status: chatBloc.state.status == ChatStatus.loading
                ? SharedD_Button_Status.loading
                : controller.text.isEmpty
                    ? SharedD_Button_Status.disabled
                    : SharedD_Button_Status.enabled,
            onPressed: () => _onSumbit(context),
          ),
        ),
      ],
    );
  }
}
