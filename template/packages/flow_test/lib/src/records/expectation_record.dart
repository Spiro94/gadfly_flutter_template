import 'package:flow_test/flow_test.dart';

/// {@template ftExpectationRecord}
/// A record of the expectation
/// {@endtemplate}
class FTExpectationRecord extends FTRecord {
  /// {@macro ftExpectationRecord}
  FTExpectationRecord({
    required String description,
  }) : _description = description;

  /// The description of the user action
  final String _description;

  @override
  String toPrint() {
    return _description;
  }

  @override
  String toMarkdown() {
    return _description;
  }
}
