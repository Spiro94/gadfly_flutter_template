// ignore_for_file: lines_longer_than_80_chars

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';
import 'widgets/connector/app_bar.dart';
import 'widgets/listener/on_forgot_password_status_change.dart';
import 'widgets/molecule/reset_password_form.dart';

@RoutePage()
class ForgotPassword_Page extends StatelessWidget {
  const ForgotPassword_Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ForgotPassword_Body();
  }
}

class ForgotPassword_Body extends StatelessWidget {
  const ForgotPassword_Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordL_OnForgotPasswordStatusChange(
      child: Scaffold(
        appBar: AppBar(
          title: const ForgotPasswordC_AppBar(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(context.spacings.large),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                ForgotPasswordM_ResetPasswordForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
