import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/router.dart';
import '../../../../../blocs/reset_password/bloc.dart';
import '../../../../../blocs/reset_password/state.dart';
import '../../../../../i18n/translations.g.dart';
import '../../../../../theme/theme.dart';

class ResetPasswordL_OnStatusChange extends StatelessWidget {
  const ResetPasswordL_OnStatusChange({
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
        final sm = ScaffoldMessenger.of(context);

        switch (state.status) {
          case ResetPasswordStatus.loading:
          case ResetPasswordStatus.idle:
            break;

          case ResetPasswordStatus.error:
            sm.hideCurrentSnackBar();
            sm.showSnackBar(
              SnackBar(
                backgroundColor: context.tokens.color.error.midLow,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.t.resetPassword.ctas.resetPassword.error,
                      style:
                          TextStyle(color: context.tokens.color.error.midHigh),
                    ),
                  ],
                ),
              ),
            );

          case ResetPasswordStatus.success:
            sm.hideCurrentSnackBar();
            sm.showSnackBar(
              SnackBar(
                backgroundColor: context.tokens.color.success.midLow,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.t.resetPassword.ctas.resetPassword.success,
                      style: TextStyle(
                        color: context.tokens.color.success.midHigh,
                      ),
                    ),
                  ],
                ),
              ),
            );
            context.router.navigate(const Home_Route());
        }
      },
    );
  }
}
