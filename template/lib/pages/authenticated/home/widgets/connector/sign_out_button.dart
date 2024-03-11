import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/auth/bloc.dart';
import '../../../../../blocs/auth/event.dart';
import '../../../../../i18n/translations.g.dart';
import '../../../../../shared/widgets/dumb/button.dart';

class HomeC_SignOutButton extends StatelessWidget {
  const HomeC_SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedD_Button(
      status: SharedD_ButtonStatus.enabled,
      buttonType: SharedD_ButtonType.outlined,
      onPressed: () {
        context.read<AuthBloc>().add(AuthEvent_SignOut());
      },
      child: Text(context.t.home.signOut),
    );
  }
}
