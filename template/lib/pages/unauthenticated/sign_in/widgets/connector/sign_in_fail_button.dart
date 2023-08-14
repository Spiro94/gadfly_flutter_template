import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/auth/bloc.dart';
import '../../../../../blocs/auth/event.dart';
import '../../../../../i18n/translations.g.dart';

class SignInC_SignInFailButton extends StatelessWidget {
  const SignInC_SignInFailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle().copyWith(
        backgroundColor:
            MaterialStatePropertyAll(context.theme.colors.warning.mid),
      ),
      child: Text(context.t.signIn.signInFail),
      onPressed: () {
        context.read<AuthBloc>().add(AuthEvent_SignIn(shouldFail: true));
      },
    );
  }
}
