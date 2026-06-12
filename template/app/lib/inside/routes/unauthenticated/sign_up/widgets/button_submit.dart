import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../../../../blocs/sign_up/bloc.dart';
import '../../../../blocs/sign_up/state.dart';
import '../../../../i18n/translations.g.dart';

class SignUp_Button_Submit extends StatelessWidget {
  const SignUp_Button_Submit({required this.onSubmit, super.key});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final label = context.t.signUp.form.submit.label;
    final isLoading = context.select(
      (SignUp_Bloc bloc) => bloc.state.status == SignUp_Status.signUpInProgress,
    );

    return FButton(onPress: isLoading ? null : onSubmit, child: Text(label));
  }
}
