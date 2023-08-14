import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/router.dart';
import '../../../../../blocs/auth/bloc.dart';
import '../../../../../blocs/auth/state.dart';

@RoutePage(name: 'Unauthenticated_Routes')
class Unauthenticated_Router extends StatelessWidget {
  const Unauthenticated_Router({super.key});

  @override
  Widget build(BuildContext context) {
    return const _OnAuthStatusChange(
      child: AutoRouter(),
    );
  }
}

class _OnAuthStatusChange extends StatelessWidget {
  const _OnAuthStatusChange({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.router.root.replaceAll([const Home_Route()]);
        }
      },
      child: child,
    );
  }
}
