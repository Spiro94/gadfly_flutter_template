import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import '../../effects/shared_preferences/effect.dart';
import '../../repositories/auth/repository.dart';
import '../base_blocs.dart';
import 'event.dart';
import 'state.dart';

class AuthBloc extends AuthBaseBloc {
  AuthBloc({
    required AuthRepository authRepository,
    required SharedPreferencesEffect sharedPreferencesEffect,
    required AuthState initialState,
  })  : _authRepository = authRepository,
        _sharedPreferencesEffect = sharedPreferencesEffect,
        super(initialState) {
    on<AuthEvent_AccessTokenAdded>(
      _onAccessTokenAdded,
      transformer: sequential(),
    );
    on<AuthEvent_SignOut>(
      _onSignOut,
      transformer: sequential(),
    );
  }

  final AuthRepository _authRepository;
  final SharedPreferencesEffect _sharedPreferencesEffect;

  final _log = Logger('auth_bloc');

  Future<void> _onAccessTokenAdded(
    AuthEvent_AccessTokenAdded event,
    Emitter<AuthState> emit,
  ) async {
    // TODO: validate token
    try {
      await _sharedPreferencesEffect.setString(
        'accessToken',
        event.accessToken,
      );
    } catch (e) {
      _log.warning('access token not saved to shared preferences');
      _log.fine(e);
    } finally {
      emit(
        AuthState(
          status: AuthStatus.authenticated,
          accessToken: event.accessToken,
        ),
      );
    }
  }

  Future<void> _onSignOut(
    AuthEvent_SignOut event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      _log.warning('sign out error');
      _log.fine(e);
    }

    try {
      await _sharedPreferencesEffect.clear();
    } catch (e) {
      _log.warning('could not clear shared preferences');
      _log.fine(e);
    }

    emit(
      const AuthState(
        status: AuthStatus.unauthentcated,
        accessToken: null,
      ),
    );
  }
}
