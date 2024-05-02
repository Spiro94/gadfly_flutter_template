import 'package:auto_route/auto_route.dart';
import 'package:logging/logging.dart';

import '../../blocs/auth/bloc.dart';
import '../../blocs/auth/state.dart';
import '../app_router.dart';

class UnauthenticatedGuard extends AutoRouteGuard {
  UnauthenticatedGuard({required this.authBloc});

  final AuthBloc authBloc;
  final _log = Logger('unauthenticated_guard');

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (authBloc.state.status == AuthStatus.unauthentcated) {
      resolver.next();
    } else {
      _log.info('already authenticated');
      router.root.replaceAll(const [Home_Route()]);
    }
  }
}
