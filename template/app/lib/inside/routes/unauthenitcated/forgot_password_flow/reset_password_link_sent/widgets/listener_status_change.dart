import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../../../../../blocs/reset_password/bloc.dart';
import '../../../../../blocs/reset_password/state.dart';
import '../../../../../i18n/translations.g.dart';

class ResetPasswordLinkSent_Listener_StatusChange extends StatelessWidget {
  const ResetPasswordLinkSent_Listener_StatusChange({
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
        switch (state.status) {
          case ResetPasswordStatus.resendResetPasswordLinkError:
            {
              final scaffoldBackgroundColor =
                  context.theme.scaffoldStyle.backgroundColor;
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
          case ResetPasswordStatus.resendResetPasswordLinkSuccess:
            {
              final scaffoldBackgroundColor =
                  context.theme.scaffoldStyle.backgroundColor;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: scaffoldBackgroundColor,
                  content: FAlert(
                    title: Text(context.t.resetPasswordLinkSent.resend.success),
                    style: FAlertStyle.primary,
                  ),
                ),
              );
            }
          case ResetPasswordStatus.resendResetPasswordLinkInProgress:
          case ResetPasswordStatus.sendResetPasswordLinkInProgress:
          case ResetPasswordStatus.sendResetPasswordLinkError:
          case ResetPasswordStatus.sendResetPasswordLinkSuccess:
          case ResetPasswordStatus.resetPasswordInProgress:
          case ResetPasswordStatus.resetPasswordError:
          case ResetPasswordStatus.resetPasswordSuccess:
          case ResetPasswordStatus.idle:
            break;
        }
      },
    );
  }
}
