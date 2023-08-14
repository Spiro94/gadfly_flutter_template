import 'package:flutter/material.dart';

import '../connector/sign_in_fail_button.dart';
import '../connector/sign_in_success_button.dart';

class SignInM_SignInButtons extends StatelessWidget {
  const SignInM_SignInButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SignInC_SignInSuccessButton(),
        SizedBox(
          width: 8,
        ),
        SignInC_SignInFailButton(),
      ],
    );
  }
}
