import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../../../../blocs/sign_up/bloc.dart';
import '../../../../blocs/sign_up/state.dart';
import '../../../../i18n/translations.g.dart';
import '../../../router.dart';

class SignUp_Listener_StatusChange extends StatelessWidget {
  const SignUp_Listener_StatusChange({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final scaffoldBackgroundColor =
            context.theme.scaffoldStyle.backgroundColor;

        switch (state.status) {
          case SignUpStatus.signUpError:
          case SignUpStatus.resendEmailVerificationLinkError:
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

          case SignUpStatus.resendEmailVerificationLinkSuccess:
            {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: scaffoldBackgroundColor,
                  content: FAlert(
                    title: Text(
                      context.t.signUp.resendEmailVerification.dialog.submit
                          .success,
                    ),
                    style: FAlertStyle.primary,
                  ),
                ),
              );
              context.router.navigate(const EmailVerificationLinkSent_Route());
            }
          case SignUpStatus.signUpSuccess:
            context.router.navigate(const EmailVerificationLinkSent_Route());

          case SignUpStatus.signUpInProgress:
          case SignUpStatus.resendEmailVerificationLinkInProgress:
          case SignUpStatus.idle:
            break;
        }
      },
      child: child,
    );
  }
}
