import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/auth/bloc.dart';
import '../../../../../blocs/auth/event.dart';
import '../../../../../i18n/translations.g.dart';

class SignInC_SignInSuccessButton extends StatelessWidget {
  const SignInC_SignInSuccessButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(context.t.signIn.signInSuccess),
      onPressed: () {
        context.read<AuthBloc>().add(AuthEvent_SignIn(shouldFail: false));
      },
    );
  }
}
