// ignore_for_file: lines_longer_than_80_chars

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/theme.dart';
import '../../../blocs/sign_in/bloc.dart';
import '../../../repositories/auth/repository.dart';
import 'widgets/connector/app_bar.dart';
import 'widgets/connector/redirect_to_sign_up_link.dart';
import 'widgets/listener/on_sign_in_status_change.dart';
import 'widgets/molecule/sign_in_form.dart';

@RoutePage()
class SignIn_Page extends StatelessWidget {
  const SignIn_Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SignInBloc(authRepository: context.read<AuthRepository>()),
      child: const SignIn_Scaffold(),
    );
  }
}

class SignIn_Scaffold extends StatelessWidget {
  const SignIn_Scaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SignInL_OnSignInStatusChange(
      child: Scaffold(
        appBar: const SignUpC_AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(context.spacings.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SignInM_SignInForm(),
                SizedBox(height: context.spacings.xxxxLarge),
                const SignInC_RedirectToSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
