import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../blocs/extension/bloc.dart';
import '../models/log_filter.dart';
import '../models/log_record.dart';
import 'bloc_event_tile.dart';
import 'log_record_tile.dart';

class LeftPane extends StatelessWidget {
  const LeftPane({
    required this.autoScrollController,
    super.key,
  });

  final AutoScrollController autoScrollController;

  List<BDELogRecord> _effectiveLogs({
    required List<BDELogRecord> logRecords,
    required BDELogFilter selectedLogFilter,
  }) {
    switch (selectedLogFilter) {
      case BDELogFilter.error:
        return logRecords
            .where((log) => {
                  'SHOUT',
                  'SEVERE',
                  'ERROR',
                }.contains(log.level.toUpperCase()),)
            .toList();
      case BDELogFilter.warning:
        return logRecords
            .where((log) => {
                  'SHOUT',
                  'SEVERE',
                  'ERROR',
                  'WARNING',
                }.contains(log.level.toUpperCase()),)
            .toList();
      case BDELogFilter.info:
        return logRecords
            .where((log) => {
                  'SHOUT',
                  'SEVERE',
                  'ERROR',
                  'WARNING',
                  'INFO',
                }.contains(log.level.toUpperCase()),)
            .toList();
      case BDELogFilter.all:
        return logRecords;
      case BDELogFilter.none:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final extensionBloc = context.watch<ExtensionBloc>();
    final events = extensionBloc.state.events;
    final selectedLogFilter = extensionBloc.state.selectedLogFilter;

    final items = [
      for (final (index, e) in events.indexed)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final log in _effectiveLogs(
              logRecords: e.payload.logs,
              selectedLogFilter: selectedLogFilter,
            )) ...[
              LogRecordTile(log: log),
            ],
            AutoScrollTag(
              key: ValueKey('$index-${e.payload.eventName}'),
              controller: autoScrollController,
              index: index,
              child: BlocEventTile(
                index: index,
                eventPayloadWithAppStates: e,
              ),
            ),
          ],
        ),
    ];

    return ListView.builder(
      controller: autoScrollController,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index];
      },
    );
  }
}
