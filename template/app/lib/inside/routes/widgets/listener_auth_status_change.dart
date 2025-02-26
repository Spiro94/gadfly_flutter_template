import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/bloc.dart';
import '../../blocs/auth/state.dart';
import '../router.dart';

class Routes_Listener_AuthStatusChange extends StatelessWidget {
  const Routes_Listener_AuthStatusChange({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<Auth_Bloc, Auth_State>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case Auth_Status.unauthentcated:
            context.router.root.replaceAll([const SignIn_Route()]);
          case Auth_Status.authenticated:
            context.router.root.replaceAll([const Home_Route()]);
        }
      },
      child: child,
    );
  }
}
