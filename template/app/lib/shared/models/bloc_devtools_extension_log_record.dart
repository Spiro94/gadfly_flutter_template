import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';

part 'bloc_devtools_extension_log_record.g.dart';

@JsonSerializable(createFactory: false)
class SharedModel_BlocDevtoolsExtension_LogRecord {
  SharedModel_BlocDevtoolsExtension_LogRecord({required LogRecord logRecord})
    : level = logRecord.level.name,
      message = logRecord.message,
      loggerName = logRecord.loggerName,
      time = logRecord.time,
      error = logRecord.error?.toString();

  final String level;
  final String loggerName;
  final String message;
  final DateTime time;
  final String? error;

  Map<String, dynamic> toJson() =>
      _$SharedModel_BlocDevtoolsExtension_LogRecordToJson(this);
}
