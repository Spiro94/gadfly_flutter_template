import 'package:flow_test/src/mocked_app.dart';
import 'package:flow_test/src/records/expectation_record.dart';
import 'package:flutter_test/flutter_test.dart' as ft;

class FTExpectations<M> {
  FTExpectations({
    required FTMockedApp<M> mockedApp,
    required this.expectationRecords,
  })  : extras = mockedApp.extras,
        mocks = mockedApp.mocks;

  final Map<String, dynamic> extras;
  final M mocks;
  final List<FTExpectationRecord> expectationRecords;

  void expect(
    dynamic actual,
    dynamic matcher, {
    required String reason,
    dynamic skip,
  }) {
    expectationRecords.add(FTExpectationRecord(description: reason));
    ft.expect(
      actual,
      matcher,
      reason: reason,
      skip: skip,
    );
  }
}
