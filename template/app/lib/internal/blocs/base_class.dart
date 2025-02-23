import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/mixins/logging.dart';

/// Blocs will be instantiated inside of the widget tree.
class Base_Bloc<Event, State> extends Bloc<Event, State>
    with SharedMixin_Logging {
  Base_Bloc(super.initialState);
}
