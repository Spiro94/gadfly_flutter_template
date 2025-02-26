import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/mixins/logging.dart';

/// Blocs will be instantiated inside of the widget tree.
class Bloc_Base<Event, State> extends Bloc<Event, State>
    with SharedMixin_Logging {
  Bloc_Base(super.initialState);
}
