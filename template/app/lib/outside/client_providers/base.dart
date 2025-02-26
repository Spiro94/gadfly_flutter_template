import '../../shared/mixins/logging.dart';

abstract class ClientProvider_Base with SharedMixin_Logging {
  Future<void> init();
}
