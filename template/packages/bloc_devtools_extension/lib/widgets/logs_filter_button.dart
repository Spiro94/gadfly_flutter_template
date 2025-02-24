import 'package:flutter/material.dart';
import '../models/log_filter.dart';

class LogsFilterButton extends StatelessWidget {
  const LogsFilterButton({
    required this.selectedLogFilter,
    required this.onSetLogsFilter,
    super.key,
  });

  final BDELogFilter selectedLogFilter;
  final void Function(BDELogFilter value) onSetLogsFilter;

  Color? _color(BDELogFilter filter) {
    return filter == selectedLogFilter ? Colors.teal : null;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<BDELogFilter>(
      icon: const Icon(Icons.filter_list),
      onSelected: onSetLogsFilter,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: BDELogFilter.none,
            child: Text(
              'NONE',
              style: TextStyle(color: _color(BDELogFilter.none)),
            ),
          ),
          PopupMenuItem(
            value: BDELogFilter.error,
            child: Text('ERROR',
                style: TextStyle(color: _color(BDELogFilter.error)),),
          ),
          PopupMenuItem(
            value: BDELogFilter.warning,
            child: Text('WARNING',
                style: TextStyle(color: _color(BDELogFilter.warning)),),
          ),
          PopupMenuItem(
            value: BDELogFilter.info,
            child: Text('INFO',
                style: TextStyle(color: _color(BDELogFilter.info)),),
          ),
          PopupMenuItem(
            value: BDELogFilter.all,
            child:
                Text('ALL', style: TextStyle(color: _color(BDELogFilter.all))),
          ),
        ];
      },
    );
  }
}
