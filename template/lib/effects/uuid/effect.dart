// coverage:ignore-file

import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

class UuidEffect {
  final _log = Logger('uuid_effect');

  final _uuid = const Uuid();

  /// This created a v4 uuid
  String generateUuidV4({
    required String debugLabel,
  }) {
    final _v4 = _uuid.v4();
    _log.fine('uuid: $_v4');
    return _v4;
  }
}
