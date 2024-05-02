import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/auth/bloc.dart';
import '../../../../blocs/auth/event.dart';
import '../../../../i18n/translations.g.dart';
import '../../../../shared/widgets/button.dart';

class Home_SignOutButton extends StatelessWidget {
  const Home_SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shared_Button(
      status: Shared_ButtonStatus.enabled,
      buttonType: Shared_ButtonType.outlined,
      onPressed: () {
        context.read<AuthBloc>().add(AuthEvent_SignOut());
      },
      child: Text(context.t.home.signOut),
    );
  }
}
