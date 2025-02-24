// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BDELogRecord _$BDELogRecordFromJson(Map<String, dynamic> json) => BDELogRecord(
      level: json['level'] as String,
      loggerName: json['loggerName'] as String,
      message: json['message'] as String,
      time: DateTime.parse(json['time'] as String),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$BDELogRecordToJson(BDELogRecord instance) =>
    <String, dynamic>{
      'level': instance.level,
      'loggerName': instance.loggerName,
      'message': instance.message,
      'time': instance.time.toIso8601String(),
      'error': instance.error,
    };
