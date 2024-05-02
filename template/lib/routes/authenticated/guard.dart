import 'package:auto_route/auto_route.dart';
import 'package:logging/logging.dart';

import '../../blocs/auth/bloc.dart';
import '../../blocs/auth/state.dart';
import '../app_router.dart';

class AuthenticatedGuard extends AutoRouteGuard {
  AuthenticatedGuard({required this.authBloc});

  final AuthBloc authBloc;
  final _log = Logger('authenticated_guard');

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (authBloc.state.status == AuthStatus.authenticated) {
      resolver.next();
    } else {
      _log.info('not authenticated');
      router.root.replaceAll(const [SignIn_Route()]);
    }
  }
}
