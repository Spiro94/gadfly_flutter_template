import '../../app/builder.dart';
import '../../app/runner.dart';
import '../../shared/mixins/logging.dart';

/// Repositories will be instantiated in [appRunner] before [appBuilder] is run.
/// Repositories are singletons and have the opporunity to optionally run an
/// [init] method.
abstract class Base_Repository with SharedMixin_Logging {
  Future<void> init();
}
