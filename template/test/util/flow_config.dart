import 'package:flow_test/flow_test.dart';

import 'util.dart';

FTConfig<MocksContainer> createFlowConfig({
  required bool hasAccessToken,
}) =>
    FTConfig<MocksContainer>(
      mockedApps: createdMockedApps(hasAccessToken: hasAccessToken),
      createBlocObserver: createTestBlocObserver,
      onListItemRegexes: [
        FTOnRegexMatch(
          regex: RegExp('LOG'),
          onMatch: (match) => 'log',
        ),
        FTOnRegexMatch(
          regex: RegExp('Page'),
          onMatch: (match) => 'page',
        ),
        FTOnRegexMatch(
          regex: RegExp('Track'),
          onMatch: (match) => 'track',
        ),
      ],
    );
