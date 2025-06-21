import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import '../../../../blocs/auth/bloc.dart';
import '../../../../blocs/auth/events.dart';

class Home_Icon_SignOut extends StatelessWidget {
  const Home_Icon_SignOut({super.key});

  @override
  Widget build(BuildContext context) {
    return FButton.icon(
      onPress: () {
        context.read<Auth_Bloc>().add(Auth_Event_SignOut());
      },
      child: const Icon(FIcons.logOut),
    );
  }
}
