import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/theme/theme.dart';
import '../../../../../blocs/chat/bloc.dart';

class HomeC_MessagesContainer extends StatelessWidget {
  const HomeC_MessagesContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.watch<ChatBloc>();
    final messages = chatBloc.state.messages;

    return ColoredBox(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: context.spacings.medium,
              ),
              ...messages.map((e) => _Message(message: e)),
              SizedBox(
                height: context.spacings.medium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.spacings.xSmall),
      child: Text(
        message,
        textAlign: TextAlign.center,
      ),
    );
  }
}
