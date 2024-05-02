import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/sign_up/bloc.dart';
import '../../../../../blocs/sign_up/state.dart';
import '../../../../../i18n/translations.g.dart';
import '../../../../../theme/theme.dart';

class SignUpC_SignUpStatusChangeListener extends StatelessWidget {
  const SignUpC_SignUpStatusChangeListener({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case SignUpStatus.error:
            final sm = ScaffoldMessenger.of(context);
            sm.hideCurrentSnackBar();
            sm.showSnackBar(
              SnackBar(
                backgroundColor: context.tokens.color.error.container,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.t.signUp.ctas.signUp.error,
                      style: TextStyle(
                        color: context.tokens.color.error.onContainer,
                      ),
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
