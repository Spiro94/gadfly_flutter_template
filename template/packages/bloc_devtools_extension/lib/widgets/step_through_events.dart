import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/extension/bloc.dart';
import '../blocs/extension/events.dart';
import 'logs_filter_button.dart';

class StepThroughEvents extends StatelessWidget {
  const StepThroughEvents({
    required this.onSetSelectedEventIndex, super.key,
  });

  final void Function(int index) onSetSelectedEventIndex;

  @override
  Widget build(BuildContext context) {
    final extensionBloc = context.watch<ExtensionBloc>();
    final effectiveEventIndex = extensionBloc.state.effectiveEventIndex;
    final events = extensionBloc.state.events;
    final selectedLogFilter = extensionBloc.state.selectedLogFilter;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        OutlinedButton(
          onPressed: () {
            final previousIndexCandidate = effectiveEventIndex - 1;
            if (previousIndexCandidate >= 0) {
              onSetSelectedEventIndex(previousIndexCandidate);
            } else {
              onSetSelectedEventIndex(events.length - 1);
            }
          },
          child: const Text('Previous Event'),
        ),
        OutlinedButton(
          onPressed: () {
            final nextIndexCandidate = effectiveEventIndex + 1;

            if (nextIndexCandidate < events.length) {
              onSetSelectedEventIndex(nextIndexCandidate);
            } else {
              onSetSelectedEventIndex(0);
            }
          },
          child: const Text('Next Event'),
        ),
        LogsFilterButton(
          selectedLogFilter: selectedLogFilter,
          onSetLogsFilter: (logsFilter) {
            extensionBloc.add(
              ExtensionEvent_SetSelectedLogFilter(
                selectedLogFilter: logsFilter,
              ),
            );
          },
        ),
      ],
    );
  }
}
