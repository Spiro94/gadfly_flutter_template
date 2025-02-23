import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'log_record.dart';

part 'bloc_event_payload.g.dart';

@JsonSerializable()
class BDEBlocEventPayload extends Equatable {
  const BDEBlocEventPayload({
    required this.blocName,
    required this.blocState,
    required this.eventName,
    required this.logs,
  });

  @JsonKey(name: 'bloc_name')
  final String blocName;

  @JsonKey(name: 'bloc_state', fromJson: _blocStateFromJson)
  final Map<String, dynamic>? blocState;

  static dynamic _blocStateFromJson(String? blocState) {
    if (blocState == null || blocState.isEmpty) {
      return null;
    }

    return jsonDecode(blocState);
  }

  @JsonKey(name: 'event_name')
  final String eventName;

  @JsonKey(
    name: 'logs',
    fromJson: _logsFromJson,
  )
  final List<BDELogRecord> logs;

  // Note: when I tried to change the lints to very_good_analysis, I got some
  // issues here. If I tried to fix them, then the extension breaks. So simply
  // using flutter_lints, which doesn't complain about the code here, and it
  // works. Should circle back and figure this out though..
  static List<BDELogRecord> _logsFromJson(String logs) {
    final logRecords = <BDELogRecord>[];

    final decodedLogs = jsonDecode(logs);
    decodedLogs.forEach((log) {
      logRecords.add(BDELogRecord.fromJson(log));
    });

    return logRecords;
  }

  @override
  List<Object?> get props => [
        blocName,
        jsonEncode(blocState),
        eventName,
        logs,
      ];

  factory BDEBlocEventPayload.fromJson(Map<String, dynamic> json) =>
      _$BDEBlocEventPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$BDEBlocEventPayloadToJson(this);
}
