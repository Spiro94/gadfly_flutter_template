import 'package:auto_route/auto_route.dart';

import '../../../../../shared/mixins/logging.dart';
import '../../../../util/validators.dart';
import '../../../router.dart';

/// Should only be able to get to this page if there is an email query parameter
class ResetPasswordLinkSent_Guard extends AutoRouteGuard
    with SharedMixin_Logging {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final email = resolver.route.queryParams.optString('email');
    log.info('email: $email');
    if (email != null &&
        email.isNotEmpty &&
        InsideUtil_Validators.isEmailValid(Uri.decodeComponent(email))) {
      resolver.next();
    } else {
      // coverage:ignore-start
      log.info('no email query parameter');
      router.root.replaceAll(const [SignIn_Route()]);
      // coverage:ignore-end
    }
  }
}
