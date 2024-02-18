import 'package:flutter_test/flutter_test.dart';
import 'package:gadfly_flutter_template/repositories/auth/repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class FakeSession extends Fake implements Session {
  @override
  final accessToken = 'fakeAccessToken';
}

class FakeAuthResponse extends Fake implements AuthResponse {}

void main() {
  const deepLinkHostname = 'faskDeepLinkHostname';
  late SupabaseClient supabaseClient;
  late GoTrueClient goTrueClient;

  setUp(() {
    supabaseClient = MockSupabaseClient();
    goTrueClient = MockGoTrueClient();
  });

  group('AuthRepository', () {
    test('forgotPassword', () {
      final targetUnderTest = AuthRepository(
        deepLinkHostname: deepLinkHostname,
        supabaseClient: supabaseClient,
      );

      when(() => supabaseClient.auth).thenReturn(goTrueClient);

      Future<void> method() => goTrueClient.resetPasswordForEmail(
            'foo@example.com',
            redirectTo: any(named: 'redirectTo'),
            captchaToken: null,
          );

      when(method).thenAnswer((invocation) async {
        return;
      });

      targetUnderTest.forgotPassword(email: 'foo@example.com');

      verify(
        method,
      ).called(1);
    });

    test('resetPassword', () {
      final targetUnderTest = AuthRepository(
        deepLinkHostname: deepLinkHostname,
        supabaseClient: supabaseClient,
      );

      when(() => supabaseClient.auth).thenReturn(goTrueClient);

      registerFallbackValue(UserAttributes());
      Future<UserResponse> method() => goTrueClient.updateUser(
            any(),
          );

      when(method).thenAnswer((invocation) async {
        return UserResponse.fromJson({});
      });

      targetUnderTest.resetPassword(password: 'password');

      verify(
        method,
      ).called(1);
    });

    test('setSessionFromUri', () {
      final targetUnderTest = AuthRepository(
        deepLinkHostname: deepLinkHostname,
        supabaseClient: supabaseClient,
      );

      when(() => supabaseClient.auth).thenReturn(goTrueClient);

      registerFallbackValue(Uri());
      Future<AuthSessionUrlResponse> method() => goTrueClient.getSessionFromUrl(
            any(),
          );

      when(method).thenAnswer((invocation) async {
        return AuthSessionUrlResponse(
          session: FakeSession(),
          redirectType: 'redirectType',
        );
      });

      targetUnderTest.setSessionFromUri(uri: Uri());

      verify(
        method,
      ).called(1);
    });

    test('signIn', () {
      final targetUnderTest = AuthRepository(
        deepLinkHostname: deepLinkHostname,
        supabaseClient: supabaseClient,
      );

      when(() => supabaseClient.auth).thenReturn(goTrueClient);

      Future<AuthResponse> method() => goTrueClient.signInWithPassword(
            email: 'foo@example.com',
            password: 'password',
          );

      when(method).thenAnswer((invocation) async {
        return FakeAuthResponse();
      });

      targetUnderTest.signIn(
        email: 'foo@example.com',
        password: 'password',
      );

      verify(
        method,
      ).called(1);
    });

    test('signOut', () {
      final targetUnderTest = AuthRepository(
        deepLinkHostname: deepLinkHostname,
        supabaseClient: supabaseClient,
      );

      when(() => supabaseClient.auth).thenReturn(goTrueClient);

      Future<void> method() => goTrueClient.signOut();

      when(method).thenAnswer((invocation) async {
        return;
      });

      targetUnderTest.signOut();

      verify(
        method,
      ).called(1);
    });

    test('signUp', () {
      final targetUnderTest = AuthRepository(
        deepLinkHostname: deepLinkHostname,
        supabaseClient: supabaseClient,
      );

      when(() => supabaseClient.auth).thenReturn(goTrueClient);

      Future<AuthResponse> method() => goTrueClient.signUp(
            email: 'foo@example.com',
            password: 'password',
          );

      when(method).thenAnswer((invocation) async {
        return FakeAuthResponse();
      });

      targetUnderTest.signUp(
        email: 'foo@example.com',
        password: 'password',
      );

      verify(
        method,
      ).called(1);
    });
  });
}
