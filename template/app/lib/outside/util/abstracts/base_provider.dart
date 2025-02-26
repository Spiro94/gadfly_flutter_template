import '../../../app/builder.dart';
import '../../../app/runner.dart';
import '../../../shared/mixins/logging.dart';

/// Base Providers will be instantiated in [appRunner] before [appBuilder] is
/// run. Base Providers are singletons and have the opporunity to optionally
/// run an [init] method.
abstract class OutsideUtilAbstract_BaseProvider with SharedMixin_Logging {
  Future<void> init();
}
