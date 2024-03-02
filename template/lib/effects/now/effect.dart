// coverage:ignore-file

import 'package:logging/logging.dart';

class NowEffect {
  final _log = Logger('now_effect');

  DateTime now({
    required String debugLabel,
  }) {
    final _now = DateTime.now();
    _log.fine('now: $_now');
    return _now;
  }
}
