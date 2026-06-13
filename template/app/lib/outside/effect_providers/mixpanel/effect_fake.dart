import '../../../shared/mixins/logging.dart';
import 'effect.dart';

class Effect_Mixpanel_Fake with SharedMixin_Logging implements Mixpanel_Effect {
  @override
  void setUser({required String? sub, required String? email}) {
    log.info('set user');
    log.fine('sub: $sub');
    log.fine('email: $email');
  }

  @override
  void reset() {
    log.info('reset');
  }

  @override
  Future<void> trackEvent({
    required String event,
    Map<String, dynamic>? properties,
  }) async {
    log.info('[track]: $event');
  }

  @override
  Future<void> trackPage({
    required String pageName,
    required bool isPopped,
    Map<String, dynamic>? properties,
  }) async {
    final event = isPopped ? 'page_popped: $pageName' : '[page]: $pageName';
    log.info(event);
  }
}
