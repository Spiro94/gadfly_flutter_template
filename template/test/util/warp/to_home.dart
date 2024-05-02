import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocked_app.dart';

// Note: Set `hasAccessToken` to true when warping

Future<void> arrangeBeforeWarpToHome(
  FTArrange<MocksContainer> arrange,
) async {
  // From AuthBloc
  when(
    () => arrange.mocks.sharedPreferencesEffect.setString('accessToken', any()),
  ).thenAnswer((invocation) async => true);
}
