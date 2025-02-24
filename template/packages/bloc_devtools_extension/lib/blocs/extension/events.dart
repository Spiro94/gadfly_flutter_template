import '../../models/bloc_event_payload.dart';
import '../../models/json_filter.dart';
import '../../models/log_filter.dart';

abstract class ExtensionEvent {}

class ExtensionEvent_Reset extends ExtensionEvent {}

class ExtensionEvent_AddBlocEvent extends ExtensionEvent {
  ExtensionEvent_AddBlocEvent({
    required this.blocEventPayload,
  });

  final BDEBlocEventPayload blocEventPayload;
}

class ExtensionEvent_SetSelectedEventIndex extends ExtensionEvent {
  ExtensionEvent_SetSelectedEventIndex({
    required this.selectedEventIndex,
  });

  final int? selectedEventIndex;
}

class ExtensionEvent_SetSelectedJsonFilter extends ExtensionEvent {
  ExtensionEvent_SetSelectedJsonFilter({
    required this.selectedJsonFilter,
  });

  final BDEJsonFilter selectedJsonFilter;
}

class ExtensionEvent_SetSelectedLogFilter extends ExtensionEvent {
  ExtensionEvent_SetSelectedLogFilter({
    required this.selectedLogFilter,
  });

  final BDELogFilter selectedLogFilter;
}
