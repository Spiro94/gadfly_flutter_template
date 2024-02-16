// ignore_for_file: lines_longer_than_80_chars

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../theme/theme.dart';
import '../forgot_password/widgets/connector/app_bar.dart';
import 'widgets/connector/resend_email_button.dart';
import 'widgets/connector/subtitle_text.dart';
import 'widgets/listener/on_forgot_password_status_change.dart';

@RoutePage()
class ForgotPasswordConfirmation_Page extends StatelessWidget {
  const ForgotPasswordConfirmation_Page({
    @QueryParam() this.email,
    super.key,
  });

  final String? email;

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordConfirmation_Body(
      email: Uri.decodeComponent(email ?? ''),
    );
  }
}

class ForgotPasswordConfirmation_Body extends StatelessWidget {
  const ForgotPasswordConfirmation_Body({
    required this.email,
    super.key,
  });

  final String email;

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordConfirmationL_OnForgotPasswordStatusChange(
      child: Scaffold(
        appBar: const ForgotPasswordC_AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(context.tokens.spacing.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const ForgotPasswordConfirmationC_SubtitleText(),
                SizedBox(
                  height: context.tokens.spacing.large,
                ),
                Row(
                  children: [
                    ForgotPasswordConfirmationC_ResendEmailButton(
                      email: email,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
