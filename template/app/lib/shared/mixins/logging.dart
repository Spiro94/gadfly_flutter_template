import 'package:logging/logging.dart';
import 'package:recase/recase.dart';

mixin SharedMixin_Logging {
  Logger get log {
    return Logger(runtimeType.toString().snakeCase);
  }
}
