import 'package:amplitude_repository/amplitude_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repositories/auth/repository.dart';
import '../base_blocs.dart';
import 'event.dart';
import 'state.dart';

class AuthBloc extends AuthBaseBloc {
  AuthBloc({
    required SharedPreferences sharedPreferences,
    required AuthRepository authRepository,
    required AmplitudeRepository amplitudeRepository,
    required AuthState initialState,
  })  : _sharedPreferences = sharedPreferences,
        _amplitudeRepository = amplitudeRepository,
        _authRepository = authRepository,
        super(initialState) {
    on<AuthEvent_SignIn>(
      _onSignIn,
      transformer: sequential(),
    );
    on<AuthEvent_SignOut>(
      _onSignOut,
      transformer: sequential(),
    );
  }

  final SharedPreferences _sharedPreferences;
  final AmplitudeRepository _amplitudeRepository;
  final AuthRepository _authRepository;

  static const authTokenSharedPrefsKey = 'authToken';

  Future<void> _onSignIn(
    AuthEvent_SignIn event,
    Emitter<AuthState> emit,
  ) async {
    await _amplitudeRepository.track(event: 'Sign In: Attemped');

    try {
      final authToken =
          await _authRepository.fakeSignIn(shouldFail: event.shouldFail);
      await _sharedPreferences.setString(authTokenSharedPrefsKey, authToken);

      emit(
        AuthState(
          status: AuthStatus.authenticated,
          authToken: authToken,
          signInStatus: AuthSignInStatus.idle,
        ),
      );
      await _amplitudeRepository.track(event: 'Sign In: Succeeded');
    } catch (e) {
      await _sharedPreferences.remove(authTokenSharedPrefsKey);

      // double yield signInStatus so can display a snackbar
      emit(
        const AuthState(
          status: AuthStatus.unauthentcated,
          authToken: null,
          signInStatus: AuthSignInStatus.error,
        ),
      );
      emit(
        state.copyWith(AuthSignInStatus.idle),
      );

      await _amplitudeRepository.track(event: 'Sign In: Failed');
    }
  }

  Future<void> _onSignOut(
    AuthEvent_SignOut event,
    Emitter<AuthState> emit,
  ) async {
    await _amplitudeRepository.track(event: 'Sign Out');

    // We are emitting first and then we will attempt to clean up token. We
    // don't want to make the user wait to sign out.
    emit(
      const AuthState(
        status: AuthStatus.unauthentcated,
        authToken: null,
        signInStatus: AuthSignInStatus.idle,
      ),
    );

    try {
      await _sharedPreferences.remove(authTokenSharedPrefsKey);
    } catch (_) {}
  }
}
