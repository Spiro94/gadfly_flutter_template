import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/reset_password/bloc.dart';
import '../../../repositories/auth/repository.dart';
import '../../../theme/theme.dart';
import 'widgets/connector/app_bar.dart';
import 'widgets/connector/status_change_listener.dart';
import 'widgets/molecule/reset_password_form.dart';

@RoutePage()
class ResetPassword_Page extends StatelessWidget {
  const ResetPassword_Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ResetPasswordBloc(
          authRepository: context.read<AuthRepository>(),
        );
      },
      child: const ResetPassword_Scaffold(),
    );
  }
}

class ResetPassword_Scaffold extends StatelessWidget {
  const ResetPassword_Scaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResetPasswordC_StatusChangeListener(
      child: Scaffold(
        appBar: const ResetPasswordC_AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(context.tokens.spacing.large),
            child: const Column(
              children: [
                ResetPasswordM_ResetPasswordForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
