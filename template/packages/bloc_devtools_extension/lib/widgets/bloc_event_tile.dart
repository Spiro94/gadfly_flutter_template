import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/extension/bloc.dart';
import '../blocs/extension/events.dart';
import '../models/bloc_event_payload_with_app_states.dart';

class BlocEventTile extends StatelessWidget {
  const BlocEventTile({
    required this.index, required this.eventPayloadWithAppStates, super.key,
  });

  final int index;
  final BDEBlocEventPayloadWithAppStates eventPayloadWithAppStates;

  @override
  Widget build(BuildContext context) {
    final selectedEventIndex =
        context.select((ExtensionBloc bloc) => bloc.state.selectedEventIndex);

    return ListTile(
        leading: Text(index.toString()),
        tileColor: index == selectedEventIndex ? Colors.teal.shade600 : null,
        title: Text(
          eventPayloadWithAppStates.payload.eventName,
          style: const TextStyle(color: Colors.white),
        ),
        onTap: () {
          final extensionBloc = context.read<ExtensionBloc>();
          if (selectedEventIndex == index) {
            extensionBloc.add(
              ExtensionEvent_SetSelectedEventIndex(selectedEventIndex: null),
            );
          } else {
            extensionBloc.add(
              ExtensionEvent_SetSelectedEventIndex(selectedEventIndex: index),
            );
          }
        },);
  }
}
