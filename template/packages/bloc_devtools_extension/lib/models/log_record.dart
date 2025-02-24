import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'log_record.g.dart';

@JsonSerializable()
class BDELogRecord extends Equatable {
  const BDELogRecord({
    required this.level,
    required this.loggerName,
    required this.message,
    required this.time,
    this.error,
  });

  final String level;
  final String loggerName;
  final String message;
  final DateTime time;
  final String? error;

  @override
  List<Object?> get props => [
        level,
        loggerName,
        message,
        time.toIso8601String(),
        error,
      ];
  factory BDELogRecord.fromJson(Map<String, dynamic> json) =>
      _$BDELogRecordFromJson(json);

  Map<String, dynamic> toJson() => _$BDELogRecordToJson(this);
}
