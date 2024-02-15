import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/sign_in/bloc.dart';
import '../../../../../blocs/sign_in/event.dart';
import '../../../../../i18n/translations.g.dart';

class SignInC_GoogleAuthButton extends StatelessWidget {
  const SignInC_GoogleAuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(
        context.t.signIn.signInWithGoogle,
      ),
      onPressed: () {
        context.read<SignInBloc>().add(SignInEvent_SignInWithGoogle());
      },
    );
  }
}
