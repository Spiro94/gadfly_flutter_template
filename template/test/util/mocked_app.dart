import 'package:amplitude_repository/amplitude_repository.dart';
import 'package:flutter/material.dart';
import 'package:gadfly_flutter_template/app/builder.dart';
import 'package:gadfly_flutter_template/app/theme.dart';
import 'package:gadfly_flutter_template/effects/now/provider.dart';
import 'package:gadfly_flutter_template/effects/shared_preferences/provider.dart';
import 'package:gadfly_flutter_template/repositories/auth/repository.dart';
import 'package:mocktail/mocktail.dart';

class MockedApp {
  const MockedApp(this.mocks);

  final MocksContainer mocks;

  Future<Widget> mockedAppBuilder() async {
    return appBuilder(
      themeMode: ThemeMode.light,
      themeDataLight: appThemeDataLight,
      themeDataDark: appThemeDataDark,
      nowEffectProvider: mocks.nowEffectProvider,
      sharedPreferencesEffectProvider: mocks.sharedPreferencesEffectProvider,
      authRepository: mocks.authRepository,
      amplitudeRepository: mocks.amplitudeRepository,
    );
  }
}

/// Container for mocks.
class MocksContainer {
  final nowEffectProvider = MockNowEffectProvider();

  // intentionally not mocked
  final sharedPreferencesEffectProvider =
      SharedPreferencesEffectProvider(prefix: 'app_');

  final authRepository = MockAuthRepository();

  final amplitudeRepository = MockAmplitudeRepository();
}

class MockNowEffectProvider extends Mock implements NowEffectProvider {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAmplitudeRepository extends Mock implements AmplitudeRepository {}
