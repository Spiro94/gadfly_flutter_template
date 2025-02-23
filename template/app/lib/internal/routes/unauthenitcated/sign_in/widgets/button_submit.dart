import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../../../../blocs/sign_in/bloc.dart';
import '../../../../blocs/sign_in/state.dart';
import '../../../../i18n/translations.g.dart';

class SignIn_Button_Submit extends StatelessWidget {
  const SignIn_Button_Submit({
    required this.onSubmit,
    super.key,
  });

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final label = context.t.signIn.form.submit.label;
    final isLoading = context.select(
      (SignInBloc bloc) => bloc.state.status == SignInStatus.signInInProgress,
    );
    return FButton(
      label: Text(label),
      onPress: isLoading ? null : onSubmit,
    );
  }
}
