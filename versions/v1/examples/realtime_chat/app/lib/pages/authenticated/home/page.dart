import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
// ATTENTION 1/4
import 'package:flutter_bloc/flutter_bloc.dart';
// --
import '../../../app/theme/theme.dart';
import '../../../blocs/chat/bloc.dart';
import '../../../blocs/chat/event.dart';
import '../../../repositories/chat/repository.dart';
import 'widgets/connector/app_bar.dart';
// ATTENTION 2/4
import 'widgets/connector/messages_container.dart';
import 'widgets/connector/send_message_container.dart';
// ---
import 'widgets/connector/sign_out_button.dart';

@RoutePage()
class Home_Page extends StatelessWidget {
  const Home_Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // ATTENTION 3/4
    return BlocProvider(
      create: (context) {
        return ChatBloc(chatRepository: context.read<ChatRepository>())
          ..add(ChatEvent_Initialize());
      },
      child: const Home_Scaffold(),
    );
    // ---
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
      // ATTENTION 4/4
      body: SizedBox.expand(
        child: Column(
          children: [
            SizedBox(
              height: context.spacings.medium,
            ),
            const HomeC_SignOutButton(),
            SizedBox(
              height: context.spacings.large,
            ),
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: context.spacings.large),
                child: const HomeC_MessagesContainer(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.spacings.large),
              child: const HomeC_SendMessageContainer(),
            ),
            SizedBox(
              height: context.spacings.large,
            ),
          ],
        ),
      ),
      // ---
    );
  }
}
