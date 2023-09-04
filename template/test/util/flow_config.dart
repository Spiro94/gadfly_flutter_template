import 'package:flow_test/flow_test.dart';

import 'util.dart';

FTConfig<MocksContainer> createFlowConfig() => FTConfig<MocksContainer>(
      mockedApps: createdMockedApps(),
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
