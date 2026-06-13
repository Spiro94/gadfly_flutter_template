import 'package:auto_route/auto_route.dart';

import '../../../shared/mixins/logging.dart';
import '../../blocs/auth/bloc.dart';
import '../../blocs/auth/state.dart';
import '../router.dart';

class Unauthenticated_Guard extends AutoRouteGuard with SharedMixin_Logging {
  Unauthenticated_Guard({required this.authBloc});

  final Auth_Bloc authBloc;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (authBloc.state.status == Auth_Status.unauthenticated) {
      resolver.next();
    } else {
      log.info('already authenticated');
      router.root.replaceAll(const [Home_Route()]);
    }
  }
}
