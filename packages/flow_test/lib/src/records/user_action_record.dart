import 'package:flow_test/flow_test.dart';

/// {@template ftUserActionRecord}
/// Every user action needs to have a description that is human-readable
/// {@endtemplate}
class FTUserActionRecord extends FTRecord {
  /// {@macro ftUserActionRecord}
  FTUserActionRecord({
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
