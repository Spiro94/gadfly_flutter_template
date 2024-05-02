import 'package:auto_route/auto_route.dart';
import 'package:logging/logging.dart';

import '../../../../app/router.dart';
import '../../../../shared/validators.dart';

/// Should only be able to get to this page if there is an email query parameter
class ForgotPasswordConfirgmationGuard extends AutoRouteGuard {
  final _log = Logger('forgot_password_confirmation_guard');

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final email = resolver.route.queryParams.optString('email');
    if (email != null &&
        email.isNotEmpty &&
        isEmailValid(Uri.decodeComponent(email))) {
      resolver.next();
    } else {
      // coverage:ignore-start
      _log.info('no email query parameter');
      router.root.replaceAll(const [SignIn_Route()]);
      // coverage:ignore-end
    }
  }
}
