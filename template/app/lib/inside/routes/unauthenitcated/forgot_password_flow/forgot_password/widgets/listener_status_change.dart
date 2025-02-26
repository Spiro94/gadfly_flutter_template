import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../../../../../blocs/reset_password/bloc.dart';
import '../../../../../blocs/reset_password/state.dart';
import '../../../../router.dart';

class ForgotPassword_Listener_StatusChange extends StatelessWidget {
  const ForgotPassword_Listener_StatusChange({
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
          case ResetPasswordStatus.sendResetPasswordLinkError:
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
          case ResetPasswordStatus.sendResetPasswordLinkSuccess:
            {
              context.router.navigate(
                ResetPasswordLinkSent_Route(
                  email: state.email,
                ),
              );
            }
          case ResetPasswordStatus.sendResetPasswordLinkInProgress:
          case ResetPasswordStatus.resendResetPasswordLinkInProgress:
          case ResetPasswordStatus.resendResetPasswordLinkError:
          case ResetPasswordStatus.resendResetPasswordLinkSuccess:
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
