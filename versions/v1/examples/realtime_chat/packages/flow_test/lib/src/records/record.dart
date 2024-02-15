/// The base class for all 'records' which are things that we want to store and
/// display back to the tester.
abstract class FTRecord {
  /// A method to print to console
  String toPrint();

  /// A method to create markdown
  String toMarkdown();
}
