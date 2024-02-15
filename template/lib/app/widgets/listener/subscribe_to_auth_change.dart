import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../blocs/auth/bloc.dart';
import '../../../blocs/auth/event.dart';
import '../../../effects/auth_change/effect.dart';
import '../../../effects/auth_change/provider.dart';

class AppL_SubscribeToAuthChange extends StatefulWidget {
  const AppL_SubscribeToAuthChange({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<AppL_SubscribeToAuthChange> createState() =>
      _AppL_SubscribeToAuthChangeState();
}

class _AppL_SubscribeToAuthChangeState
    extends State<AppL_SubscribeToAuthChange> {
  late AuthChangeEffect authChangeEffect;

  final _log = Logger('auth_change_subscription');

  @override
  void initState() {
    authChangeEffect = context.read<AuthChangeEffectProvider>().getEffect();

    authChangeEffect.listen((authState) {
      _log.info(authState.event.name);

      final authBloc = context.read<AuthBloc>();

      switch (authState.event) {
        case AuthChangeEvent.initialSession:
        case AuthChangeEvent.passwordRecovery:
        case AuthChangeEvent.tokenRefreshed:
        case AuthChangeEvent.userUpdated:
        case AuthChangeEvent.mfaChallengeVerified:
          // Not handled in this subscription
          break;
        case AuthChangeEvent.signedIn:
          authBloc.add(
            AuthEvent_AccessTokenAdded(
              accessToken: authState.session!.accessToken,
            ),
          );
        case AuthChangeEvent.userDeleted:
        case AuthChangeEvent.signedOut:
          authBloc.add(
            AuthEvent_AccessTokenRemoved(),
          );
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
