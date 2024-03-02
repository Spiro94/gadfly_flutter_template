import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocked_app.dart';

Future<void> arrangeBeforeWarpToHome(
  FTArrange<MocksContainer> arrange,
) async {
  // -- AuthRepository
  when(
    () => arrange.mocks.authRepository.getUserId(),
  ).thenAnswer((invocation) async {
    return 'fakeUserId';
  });

  // -- AudioRepository
  when(
    () => arrange.mocks.audioRepository
        .getMyRecordingsStream(userId: any(named: 'userId')),
  ).thenAnswer((invocation) async {
    return const Stream.empty();
  });
}

// Note: Set `hasAccessToken` to true
