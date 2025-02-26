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
    return BlocListener<SignUp_Bloc, SignUp_State>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final scaffoldBackgroundColor =
            context.theme.scaffoldStyle.backgroundColor;

        switch (state.status) {
          case SignUp_Status.signUpError:
          case SignUp_Status.resendEmailVerificationLinkError:
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

          case SignUp_Status.resendEmailVerificationLinkSuccess:
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
          case SignUp_Status.signUpSuccess:
            context.router.navigate(const EmailVerificationLinkSent_Route());

          case SignUp_Status.signUpInProgress:
          case SignUp_Status.resendEmailVerificationLinkInProgress:
          case SignUp_Status.idle:
            break;
        }
      },
      child: child,
    );
  }
}
