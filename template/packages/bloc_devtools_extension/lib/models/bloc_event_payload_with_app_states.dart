import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'bloc_event_payload.dart';

class BDEBlocEventPayloadWithAppStates extends Equatable {
  const BDEBlocEventPayloadWithAppStates({
    required this.payload,
    required this.previousAppState,
    required this.currentAppState,
  });
  final BDEBlocEventPayload payload;
  final Map<String, dynamic> previousAppState;
  final Map<String, dynamic> currentAppState;

  @override
  List<Object?> get props => [
        payload,
        jsonEncode(previousAppState),
        jsonEncode(currentAppState),
      ];
}
