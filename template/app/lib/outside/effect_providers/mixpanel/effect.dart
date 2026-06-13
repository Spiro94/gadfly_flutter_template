import 'dart:async';

import 'package:mixpanel_flutter/mixpanel_flutter.dart';

import '../../../shared/mixins/logging.dart';

class Mixpanel_Effect with SharedMixin_Logging {
  Mixpanel_Effect({required Mixpanel mixpanel}) : _mixpanel = mixpanel;

  final Mixpanel _mixpanel;

  void setUser({required String? sub, required String? email}) {
    log.info('set user');
    log.fine('sub: $sub');
    log.fine('email: $email');
    if (sub == null) {
      reset();
      return;
    }

    // set people properties
    _mixpanel.getPeople().setOnce(r'$distic_id', sub);
    if (email != null) {
      _mixpanel.getPeople().set(r'$email', email);
    }

    // set identity
    _mixpanel.identify(sub);
  }

  void reset() {
    log.info('reset');
    _mixpanel.reset();
  }

  Future<void> trackEvent({
    required String event,
    Map<String, dynamic>? properties,
  }) async {
    log.info('[track]: $event');
    try {
      unawaited(_mixpanel.track(event, properties: properties));
    } catch (e) {
      log.warning('track event error', e);
    }
  }

  Future<void> trackPage({
    required String pageName,
    required bool isPopped,
    Map<String, dynamic>? properties,
  }) async {
    final event = isPopped ? '[page_popped]: $pageName' : '[page]: $pageName';
    log.info(event);
    try {
      unawaited(_mixpanel.track(event, properties: properties));
    } catch (e) {
      log.warning('track page error', e);
    }
  }
}
