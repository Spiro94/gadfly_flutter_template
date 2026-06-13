import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../../../i18n/translations.g.dart';
import '../../../router.dart';

class SignIn_Link_ForgotPassword extends StatelessWidget {
  const SignIn_Link_ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final question = context.t.signIn.forgotPassword.question;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FTappable(
          onPress: () {
            context.router.navigate(const ForgotPassword_Route());
          },
          child: Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
