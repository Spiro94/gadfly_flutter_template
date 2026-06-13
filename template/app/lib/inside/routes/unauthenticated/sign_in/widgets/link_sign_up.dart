import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../../../../outside/theme/theme.dart';
import '../../../../i18n/translations.g.dart';
import '../../../router.dart';

class SignIn_Link_SignUp extends StatelessWidget {
  const SignIn_Link_SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final question = context.t.signIn.signUp.question;
    final action = context.t.signIn.signUp.action;
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
                context.router.navigate(const SignUp_Route());
              },
              child: Text(
                action,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
