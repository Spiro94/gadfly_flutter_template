import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../../../../../outside/theme/theme.dart';
import '../../../../blocs/sign_up/bloc.dart';
import '../../../../blocs/sign_up/events.dart';
import '../../../../i18n/translations.g.dart';
import 'input_email.dart';

class SignUp_Link_ResendEmailVerification extends StatelessWidget {
  const SignUp_Link_ResendEmailVerification({super.key});

  @override
  Widget build(BuildContext context) {
    final question = context.t.signUp.resendEmailVerification.question;
    final action = context.t.signUp.resendEmailVerification.action;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: context.tokens.spacing.xSmall,
      spacing: context.tokens.spacing.xSmall,
      children: [
        Text(question),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FTappable(
              onPress: () {
                final signUpBloc = context.read<SignUp_Bloc>();
                showAdaptiveDialog<void>(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => BlocProvider.value(
                    value: signUpBloc,
                    child: const _Dialog(),
                  ),
                );
              },
              child: Text(
                action,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Dialog extends StatefulWidget {
  const _Dialog();

  @override
  State<_Dialog> createState() => __DialogState();
}

class __DialogState extends State<_Dialog> {
  late final TextEditingController controller;

  void _refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();

    controller.addListener(_refresh);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FDialog(
      direction: Axis.horizontal,
      title: Text(
        context.t.signUp.resendEmailVerification.dialog.title,
      ),
      body: SignUp_Input_Email(controller: controller),
      actions: [
        FButton(
          key: const Key('cancel'),
          style: FButtonStyle.outline,
          label: Text(
            context.t.signUp.resendEmailVerification.dialog.cancel,
          ),
          onPress: () => Navigator.of(context).pop(),
        ),
        FButton(
          key: const Key('resend'),
          label: Text(
            context.t.signUp.resendEmailVerification.dialog.submit.label,
          ),
          onPress: () {
            Navigator.of(context).pop();
            context.read<SignUp_Bloc>().add(
                  SignUp_Event_ResendEmailVerificationLink(
                    email: controller.text,
                  ),
                );
          },
        ),
      ],
    );
  }
}
