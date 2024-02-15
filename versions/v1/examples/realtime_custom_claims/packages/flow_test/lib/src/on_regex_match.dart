/// {@template ftOnRegexMatch}
/// A utility to perform an action on regex match. This can be used to:
/// - add a css list item class
/// - add a Jira ticket link
/// {@endtemplate}
class FTOnRegexMatch {
  /// {@macro ftOnRegexMatch}
  FTOnRegexMatch({
    required this.regex,
    required this.onMatch,
  });

  /// The regex that will be used to see if there is a match
  final RegExp regex;

  /// Callback that is run when [regex] finds a match
  final String Function(RegExpMatch match) onMatch;
}
