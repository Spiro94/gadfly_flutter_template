import '../../shared/mixins/logging.dart';

abstract class Repository_Base with SharedMixin_Logging {
  Future<void> init();
}
