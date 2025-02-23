import '../../app/builder.dart';
import '../../app/runner.dart';
import '../../shared/mixins/logging.dart';

/// Client providers will be instantiated in [appRunner] before [appBuilder] is
/// run. Client providers are singletons and have the opporunity to optionally
/// run an [init] method.
abstract class Base_ClientProvider with SharedMixin_Logging {
  Future<void> init();
}
