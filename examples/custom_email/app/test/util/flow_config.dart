import 'package:flow_test/flow_test.dart';

import 'mocked_app.dart';
import 'test_bloc_observer.dart';

FTConfig<MocksContainer> createFlowConfig({
  required bool hasAccessToken,
  String? deepLinkOverride,
}) =>
    FTConfig<MocksContainer>(
      mockedApps: createdMockedApps(
        hasAccessToken: hasAccessToken,
        deepLinkOverride: deepLinkOverride,
      ),
      createBlocObserver: createTestBlocObserver,
      onListItemRegexes: [
        FTOnRegexMatch(
          regex: RegExp('INFO'),
          onMatch: (match) => 'info',
        ),
        FTOnRegexMatch(
          regex: RegExp('WARNING'),
          onMatch: (match) => 'warning',
        ),
        FTOnRegexMatch(
          regex: RegExp('SEVERE'),
          onMatch: (match) => 'severe',
        ),
        FTOnRegexMatch(
          regex: RegExp('SHOUT'),
          onMatch: (match) => 'shout',
        ),
      ],
    );
