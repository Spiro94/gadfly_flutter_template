import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../../../../blocs/reset_password/bloc.dart';
import '../../../../blocs/reset_password/state.dart';
import '../../../../i18n/translations.g.dart';
import '../../../router.dart';

class ResetPassword_Listener_StatusChange extends StatelessWidget {
  const ResetPassword_Listener_StatusChange({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      child: child,
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final scaffoldBackgroundColor =
            context.theme.scaffoldStyle.backgroundColor;

        switch (state.status) {
          case ResetPasswordStatus.resetPasswordError:
            {
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: scaffoldBackgroundColor,
                    content: FAlert(
                      title: Text(state.errorMessage!),
                      style: FAlertStyle.destructive,
                    ),
                  ),
                );
              }
            }
          case ResetPasswordStatus.resetPasswordSuccess:
            {
              context.router.navigate(
                const Home_Route(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: scaffoldBackgroundColor,
                  content: FAlert(
                    title: Text(context.t.resetPassword.form.submit.success),
                    style: FAlertStyle.primary,
                  ),
                ),
              );
            }
          case ResetPasswordStatus.sendResetPasswordLinkInProgress:
          case ResetPasswordStatus.sendResetPasswordLinkError:
          case ResetPasswordStatus.sendResetPasswordLinkSuccess:
          case ResetPasswordStatus.resendResetPasswordLinkInProgress:
          case ResetPasswordStatus.resendResetPasswordLinkError:
          case ResetPasswordStatus.resendResetPasswordLinkSuccess:
          case ResetPasswordStatus.resetPasswordInProgress:
          case ResetPasswordStatus.idle:
            break;
        }
      },
    );
  }
}
