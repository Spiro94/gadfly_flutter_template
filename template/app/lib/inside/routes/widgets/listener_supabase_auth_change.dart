import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../outside/effect_providers/auth_change/effect.dart';
import '../../../outside/effect_providers/auth_change/effect_provider.dart';
import '../../../shared/mixins/logging.dart';
import '../../blocs/auth/bloc.dart';
import '../../blocs/auth/events.dart';

class Routes_Listener_SupabaseAuthChange extends StatefulWidget
    with SharedMixin_Logging {
  const Routes_Listener_SupabaseAuthChange({required this.child, super.key});

  final Widget child;

  @override
  State<Routes_Listener_SupabaseAuthChange> createState() =>
      _Routes_Listener_SupabaseAuthChangeState();
}

class _Routes_Listener_SupabaseAuthChangeState
    extends State<Routes_Listener_SupabaseAuthChange> {
  late final AuthChange_Effect authChangeEffect;

  @override
  void initState() {
    authChangeEffect = context.read<AuthChange_EffectProvider>().getEffect();

    authChangeEffect.listen((change) {
      widget.log.info(change.name);

      final authBloc = context.read<Auth_Bloc>();

      switch (change.status) {
        case AuthChange_Status.other:
          // Not handled in this subscription
          break;
        case AuthChange_Status.signedIn:
          authBloc.add(
            Auth_Event_AccessTokenAdded(accessToken: change.accessToken!),
          );
        case AuthChange_Status.signedOut:
          authBloc.add(Auth_Event_AccessTokenRemoved());
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    authChangeEffect.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
