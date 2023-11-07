// ignore_for_file: public_member_api_docs

import 'package:flow_test/flow_test.dart';

class FTDescriptionsRecord<M> extends FTRecord {
  FTDescriptionsRecord({
    required this.descriptions,
    required this.config,
  });

  final List<FTDescription> descriptions;
  final FTConfig<M> config;

  String screenshotPath({
    required String resolvedCounter,
    required int tripCount,
  }) {
    final _shortDescriptions = <String>[];
    final _screenshotStories = descriptions
        .skipWhile((_description) => !_description.atScreenshotsLevel)
        .toList();

    for (final story in _screenshotStories) {
      _shortDescriptions.add(story.shortDescription);
    }

    final _subPath = _shortDescriptions.join('/');

    return '''$_subPath/$resolvedCounter.$tripCount''';
  }

  String get markdownFilePath {
    final _shortDescriptions = <String>[];
    for (final description in descriptions) {
      _shortDescriptions.add(description.shortDescription);
    }

    return _shortDescriptions.join('/');
  }

  String markdownScreenshotPath({
    required String resolvedCounter,
    required int tripCount,
    required String deviceName,
  }) {
    final _prefixToExit = <String>[];

    for (final _ in descriptions) {
      _prefixToExit.add('..');
    }

    final _shortDescriptions = <String>[];
    for (final description in descriptions) {
      if (description.atScreenshotsLevel) {
        _shortDescriptions.add('screenshots/${description.shortDescription}');
      } else {
        _shortDescriptions.add(description.shortDescription);
      }
    }
    final _prefix = _prefixToExit.join('/');
    final _subPath = _shortDescriptions.join('/');

    return '''$_prefix/flows/$_subPath/$resolvedCounter.$tripCount.$deviceName.png''';
  }

  @override
  String toPrint() {
    final _buffer = StringBuffer();

    for (final description in descriptions) {
      if (description.descriptionType != null) {
        _buffer.writeln('>${description.descriptionType}');
      }
      _buffer.writeln(description.shortDescription);
      if (description.description != null) {
        _buffer.writeln(description.description);
      }
      _buffer.writeln();
    }

    return _buffer.toString();
  }

  @override
  String toMarkdown() {
    final _buffer = StringBuffer();

    for (final description in descriptions) {
      if (description.descriptionType != null) {
        _buffer.writeln('**${description.descriptionType}**');
      }

      _buffer.writeln(
        _writeShortDescription(
          buffer: _buffer,
          shortDescription: description.shortDescription,
        ),
      );

      if (description.description != null) {
        _buffer.writeln();
        _buffer.writeln(description.description);
      }
      _buffer.writeln();
    }

    return _buffer.toString();
  }

  String _writeShortDescription({
    required StringBuffer buffer,
    required String shortDescription,
  }) {
    if (config.onShortDescriptionRegex != null) {
      final match =
          config.onShortDescriptionRegex!.regex.firstMatch(shortDescription);
      if (match != null) {
        return config.onShortDescriptionRegex!.onMatch(match);
      }
    }
    return shortDescription;
  }
}
