import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router.dart';
import '../../../blocs/auth/bloc.dart';
import '../../../blocs/auth/state.dart';

class SharedC_AuthStatusChangeListener extends StatelessWidget {
  const SharedC_AuthStatusChangeListener({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case AuthStatus.unauthentcated:
            context.router.root.replaceAll([const SignIn_Route()]);
          case AuthStatus.authenticated:
            context.router.root.replaceAll([const Home_Route()]);
        }
      },
      child: child,
    );
  }
}
