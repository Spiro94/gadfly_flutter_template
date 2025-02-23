import 'package:flutter/material.dart';
import '../models/log_record.dart';

class LogRecordTile extends StatelessWidget {
  const LogRecordTile({
    required this.log, super.key,
  });

  final BDELogRecord log;

  Color get _logColor {
    switch (log.level.toUpperCase()) {
      case 'INFO':
        return Colors.blue.shade500;
      case 'WARNING':
        return Colors.orange.shade500;
      case 'SHOUT':
      case 'SEVERE':
      case 'ERROR':
        return Colors.red.shade500;
      default:
        return Colors.grey.shade500;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 4),
        SelectableText(
          '[${log.loggerName}] ${log.message}',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade400,
          ),
        ),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            Text(
              '[${log.level}]',
              style: textTheme.labelSmall?.copyWith(
                color: _logColor,
              ),
            ),
            Text(
              '${log.time.toLocal()}',
              style: textTheme.labelSmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
