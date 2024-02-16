import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/sign_up/bloc.dart';
import '../../../../../blocs/sign_up/state.dart';
import '../../../../../i18n/translations.g.dart';

class SignUpL_OnSignUpStatusChange extends StatelessWidget {
  const SignUpL_OnSignUpStatusChange({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final colorScheme = Theme.of(context).colorScheme;

        switch (state.status) {
          case SignUpStatus.error:
            final sm = ScaffoldMessenger.of(context);
            sm.hideCurrentSnackBar();
            sm.showSnackBar(
              SnackBar(
                backgroundColor: colorScheme.errorContainer,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.t.signUp.ctas.signUp.error,
                      style: TextStyle(color: colorScheme.onErrorContainer),
                    ),
                  ],
                ),
              ),
            );

          case SignUpStatus.loading:
          case SignUpStatus.idle:
            return;
        }
      },
      child: child,
    );
  }
}
