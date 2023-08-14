// ignore_for_file: lines_longer_than_80_chars

import 'package:app_theme/app_theme.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'widgets/connector/exception_button.dart';
import 'widgets/listener/on_auth_sign_in_status_changed.dart';
import 'widgets/molecule/sign_in_buttons.dart';

@RoutePage()
class SignIn_Page extends StatelessWidget {
  const SignIn_Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SignIn_Scaffold();
  }
}

class SignIn_Scaffold extends StatelessWidget {
  const SignIn_Scaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SignInL_OnAuthSignInStatusChange(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SignInM_SignInButtons(),
              SizedBox(
                height: context.theme.spacings.medium,
              ),
              const SignInC_ExceptionButton(),
            ],
          ),
        ),
      ),
    );
  }
}
