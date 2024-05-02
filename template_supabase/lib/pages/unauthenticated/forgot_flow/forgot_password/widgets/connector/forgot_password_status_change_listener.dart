import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/router.dart';
import '../../../../../../blocs/forgot_password/bloc.dart';
import '../../../../../../blocs/forgot_password/state.dart';
import '../../../../../../i18n/translations.g.dart';
import '../../../../../../theme/theme.dart';

class ForgotPasswordC_ForgotPasswordStatusChangeListener
    extends StatelessWidget {
  const ForgotPasswordC_ForgotPasswordStatusChangeListener({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case ForgotPasswordStatus.sendLinkError:
            final sm = ScaffoldMessenger.of(context);
            sm.hideCurrentSnackBar();
            sm.showSnackBar(
              SnackBar(
                backgroundColor: context.tokens.color.error.container,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.t.forgotPassword.ctas.resetPassword.error,
                      style: TextStyle(
                        color: context.tokens.color.error.onContainer,
                      ),
                    ),
                  ],
                ),
              ),
            );

          case ForgotPasswordStatus.sendLinkSuccess:
            context.router.navigate(
              ForgotPasswordConfirmation_Route(
                email: Uri.encodeComponent(state.forgotPasswordEmail ?? ''),
              ),
            );

          case ForgotPasswordStatus.resendLinkError:
          case ForgotPasswordStatus.resendLinkSuccess:
          case ForgotPasswordStatus.loading:
          case ForgotPasswordStatus.idle:
            return;
        }
      },
      child: child,
    );
  }
}
