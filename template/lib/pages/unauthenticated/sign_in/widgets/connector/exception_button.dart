import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../../../../i18n/translations.g.dart';

class SignInC_ExceptionButton extends StatelessWidget {
  const SignInC_ExceptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle().copyWith(
        backgroundColor:
            MaterialStatePropertyAll(context.theme.colors.error.mid),
      ),
      child: Text(context.t.signIn.unhandledException),
      onPressed: () {
        throw Exception('Fake Exeception');
      },
    );
  }
}
