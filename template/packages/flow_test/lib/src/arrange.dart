import 'package:flow_test/src/mocked_app.dart';

class FTArrange<M> {
  FTArrange({
    required FTMockedApp<M> mockedApp,
  })  : extras = mockedApp.extras,
        mocks = mockedApp.mocks;

  final Map<String, dynamic> extras;
  final M mocks;
}
