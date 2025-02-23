import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/bloc_event_payload_with_app_states.dart';
import '../../models/json_filter.dart';
import '../../models/log_filter.dart';
import 'events.dart';
import 'state.dart';

class ExtensionBloc extends Bloc<ExtensionEvent, ExtensionState> {
  final SharedPreferences sharedPreferences;

  ExtensionBloc({required this.sharedPreferences})
      : super(
          const ExtensionState(
            events: [],
            appState: {},
            selectedEventIndex: null,
            selectedJsonFilter: BDEJsonFilter.raw,
            selectedLogFilter: BDELogFilter.all,
          ),
        ) {
    on<ExtensionEvent_Reset>((event, emit) {
      emit(ExtensionState(
        selectedEventIndex: null,
        events: const [],
        appState: const {},
        selectedLogFilter: state.selectedLogFilter,
        selectedJsonFilter: state.selectedJsonFilter,
      ),);
    });

    on<ExtensionEvent_AddBlocEvent>(
      (event, emit) {
        try {
          final previousAppState = Map<String, dynamic>.from(state.appState);
          final currentAppState = Map<String, dynamic>.from(previousAppState);

          currentAppState[event.blocEventPayload.blocName] =
              event.blocEventPayload.blocState;

          final events =
              List<BDEBlocEventPayloadWithAppStates>.from(state.events)
                ..add(
                  BDEBlocEventPayloadWithAppStates(
                    payload: event.blocEventPayload,
                    previousAppState: previousAppState,
                    currentAppState: currentAppState,
                  ),
                );

          emit(
            state.copyWith(
              events: events,
              appState: currentAppState,
            ),
          );
        } catch (_) {}
      },
    );

    on<ExtensionEvent_SetSelectedEventIndex>((event, emit) {
      emit(
        state.copyWith(
          setSelectedEventIndex: () => event.selectedEventIndex,
        ),
      );
    });

    on<ExtensionEvent_SetSelectedJsonFilter>((event, emit) {
      emit(
        state.copyWith(
          selectedJsonFilter: event.selectedJsonFilter,
        ),
      );

      try {
        sharedPreferences.setString(
            'jsonFilter', event.selectedJsonFilter.name,);
      } catch (_) {}
    });

    on<ExtensionEvent_SetSelectedLogFilter>((event, emit) {
      emit(
        state.copyWith(
          selectedLogFilter: event.selectedLogFilter,
        ),
      );

      try {
        sharedPreferences.setString('logFilter', event.selectedLogFilter.name);
      } catch (_) {}
    });
  }
}
