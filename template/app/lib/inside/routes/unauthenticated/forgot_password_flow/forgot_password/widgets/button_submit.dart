import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../../../../../blocs/reset_password/bloc.dart';
import '../../../../../blocs/reset_password/state.dart';
import '../../../../../i18n/translations.g.dart';

class ForgotPassword_Button_Submit extends StatelessWidget {
  const ForgotPassword_Button_Submit({required this.onSubmit, super.key});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final label = context.t.forgotPassword.form.submit.label;
    final isLoading = context.select(
      (ResetPassword_Bloc bloc) =>
          bloc.state.status ==
          ResetPassword_Status.sendResetPasswordLinkInProgress,
    );

    return FButton(onPress: isLoading ? null : onSubmit, child: Text(label));
  }
}
