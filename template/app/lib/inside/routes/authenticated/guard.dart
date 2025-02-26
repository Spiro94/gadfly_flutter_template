import 'package:auto_route/auto_route.dart';

import '../../../shared/mixins/logging.dart';
import '../../blocs/auth/bloc.dart';
import '../../blocs/auth/state.dart';
import '../router.dart';

class Authenticated_Guard extends AutoRouteGuard with SharedMixin_Logging {
  Authenticated_Guard({required this.authBloc});

  final Auth_Bloc authBloc;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (authBloc.state.status == Auth_Status.authenticated) {
      resolver.next();
    } else {
      log.info('not authenticated');
      router.root.replaceAll(const [SignIn_Route()]);
    }
  }
}
