import 'package:flow_test/flow_test.dart';

class FTScreenshotRecord<M> extends FTRecord {
  FTScreenshotRecord({
    required this.description,
    required this.resolvedCounter,
    required this.totalTripCount,
    required this.deviceName,
    required this.storiesRecord,
    required this.config,
  });

  final List<FTUserActionRecord> userActionRecords = [];
  final List<FTExpectationRecord> expectationRecords = [];
  final List<FTEventRecord> eventRecords = [];
  final FTDescriptionsRecord<M> storiesRecord;

  final String description;
  final String resolvedCounter;
  final int totalTripCount;
  final String deviceName;
  final FTConfig<M> config;

  @override
  String toPrint() {
    final _buffer = StringBuffer();

    _buffer.writeln('>>$description');
    _buffer.writeln();

    if (userActionRecords.isNotEmpty) {
      _buffer.writeln('User Actions:');

      for (final actionRecord in userActionRecords) {
        _buffer.writeln('  ${actionRecord.toPrint()}');
      }
      _buffer.writeln();
    }

    if (expectationRecords.isNotEmpty) {
      _buffer.writeln('Expect:');

      for (final expectationRecord in expectationRecords) {
        _buffer.writeln('  ${expectationRecord.toPrint()}');
      }
      _buffer.writeln();
    }

    if (eventRecords.isNotEmpty) {
      _buffer.writeln('Events:');

      for (final eventRecord in eventRecords) {
        _buffer.writeln('  ${eventRecord.toPrint()}');
      }
      _buffer.writeln();
    }
    _buffer.writeln('---');

    return _buffer.toString();
  }

  @override
  String toMarkdown() {
    final _buffer = StringBuffer();

    _buffer.writeln('## $description');
    _buffer.writeln();

    _buffer.write(
      '''
<table>
  <tbody>
   <tr>
      <td width="300" style="vertical-align:top">
''',
    );

    // Surface the user actions, if they exist
    if (userActionRecords.isNotEmpty) {
      _buffer
        ..writeln('<b>User Actions:</b>')
        ..writeln('<ul>');
      for (final userActionRecord in userActionRecords) {
        _writeListItem(buffer: _buffer, item: userActionRecord.toMarkdown());
      }
      _buffer.writeln('</ul>');
    }

    // Surface expecation reasons, if they exist
    if (expectationRecords.isNotEmpty) {
      _buffer
        ..writeln('<b>Expect:</b>')
        ..writeln('<ul>');
      for (final expectationRecord in expectationRecords) {
        _writeListItem(buffer: _buffer, item: expectationRecord.toMarkdown());
      }
      _buffer.writeln('</ul>');
    }

    /// Surface the events that were recorded, if they exist
    if (eventRecords.isNotEmpty) {
      _buffer
        ..writeln('<b>Events:</b>')
        ..writeln('<ul>');
      for (final eventRecord in eventRecords) {
        _writeListItem(buffer: _buffer, item: eventRecord.toMarkdown());
      }
    }

    // We are only going to run `toMarkdown` on the first trip, but we want to
    // see all the images from each trip.
    final _trips = List<int>.generate(totalTripCount, (i) => i);
    for (final _trip in _trips) {
      _buffer.write('''
      </td>
      <td>
      ''');

      var _width = '300';
      if (deviceName.contains('landscape') || deviceName.contains('web')) {
        _width = '700';
      }

      final _screenshotPath = storiesRecord.markdownScreenshotPath(
        deviceName: deviceName,
        resolvedCounter: resolvedCounter,
        tripCount: _trip,
      );

      _buffer.write(
        '''<img width="$_width" src="$_screenshotPath">''',
      );

      _buffer.write('''
      </td>''');
    }

    _buffer.write(
      '''
   </tr>
  </tbody>
</table>
''',
    );
    return _buffer.toString();
  }

  void _writeListItem({
    required StringBuffer buffer,
    required String item,
  }) {
    final classes = <String>[];

    if (config.onListItemRegexes != null) {
      for (final _onListItemRegex in config.onListItemRegexes!) {
        final match = _onListItemRegex.regex.firstMatch(item);
        if (match != null) {
          classes.add(_onListItemRegex.onMatch(match));
        }
      }
    }

    if (classes.isNotEmpty) {
      buffer.writeln('  <li class=${classes.join(' ')}>$item</li>');
    } else {
      buffer.writeln('  <li>$item</li>');
    }
  }
}
