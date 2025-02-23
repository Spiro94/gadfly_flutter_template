import 'package:equatable/equatable.dart';
import '../../models/bloc_event_payload_with_app_states.dart';
import '../../models/json_filter.dart';
import '../../models/log_filter.dart';

class ExtensionState extends Equatable {
  const ExtensionState({
    required this.events,
    required this.appState,
    required this.selectedEventIndex,
    required this.selectedJsonFilter,
    required this.selectedLogFilter,
  });

  final List<BDEBlocEventPayloadWithAppStates> events;
  final Map<String, dynamic> appState;

  final int? selectedEventIndex;

  int get effectiveEventIndex =>
      events.isEmpty ? -1 : selectedEventIndex ?? events.indexOf(events.last);

  final BDEJsonFilter selectedJsonFilter;
  final BDELogFilter selectedLogFilter;

  ExtensionState copyWith({
    List<BDEBlocEventPayloadWithAppStates>? events,
    Map<String, dynamic>? appState,
    int? Function()? setSelectedEventIndex,
    BDEJsonFilter? selectedJsonFilter,
    BDELogFilter? selectedLogFilter,
  }) =>
      ExtensionState(
        events: events ?? this.events,
        appState: appState ?? this.appState,
        selectedEventIndex: setSelectedEventIndex == null
            ? selectedEventIndex
            : setSelectedEventIndex(),
        selectedJsonFilter: selectedJsonFilter ?? this.selectedJsonFilter,
        selectedLogFilter: selectedLogFilter ?? this.selectedLogFilter,
      );

  @override
  List<Object?> get props => [
        events,
        appState,
        selectedEventIndex,
        selectedJsonFilter,
        selectedLogFilter,
      ];
}
