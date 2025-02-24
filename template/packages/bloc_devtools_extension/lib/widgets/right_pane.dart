import 'package:flutter/material.dart';
import 'json_display.dart';
import 'json_filter_buttons.dart';
import 'step_through_events.dart';

class RightPane extends StatelessWidget {
  const RightPane({
    required this.onSetSelectedEventIndex,
    super.key,
  });

  final void Function(int index) onSetSelectedEventIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StepThroughEvents(
                  onSetSelectedEventIndex: onSetSelectedEventIndex,),
            ),
            const Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: JsonFilterButtons(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ColoredBox(
            color: Colors.grey.shade900,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: const JsonDisplay(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
