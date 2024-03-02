import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth/repository.dart';
import '../base_blocs.dart';
import 'event.dart';
import 'state.dart';

class AuthBloc extends AuthBaseBloc {
  AuthBloc({
    required AuthRepository authRepository,
    required AuthState initialState,
  })  : _authRepository = authRepository,
        super(initialState) {
    on<AuthEvent_SignOut>(
      _onSignOut,
      transformer: sequential(),
    );
    on<AuthEvent_AccessTokenAdded>(
      _onAccessTokenAdded,
      transformer: sequential(),
    );
    on<AuthEvent_AccessTokenRemoved>(
      _onAccessTokenRemoved,
      transformer: sequential(),
    );
    on<AuthEvent_SetSessionFromDeepLink>(
      _onSetSessionFromDeepLink,
      transformer: sequential(),
    );
  }

  final AuthRepository _authRepository;

  Future<void> _onAccessTokenAdded(
    AuthEvent_AccessTokenAdded event,
    Emitter<AuthState> emit,
  ) async {
    // TODO: validate token
    emit(
      AuthState(
        status: AuthStatus.authenticated,
        accessToken: event.accessToken,
      ),
    );
  }

  Future<void> _onSignOut(
    AuthEvent_SignOut event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      // No-op
    } finally {
      await _tokenRemoved(emit);
    }
  }

  Future<void> _onAccessTokenRemoved(
    AuthEvent_AccessTokenRemoved event,
    Emitter<AuthState> emit,
  ) async {
    await _tokenRemoved(emit);
  }

  Future<void> _tokenRemoved(Emitter<AuthState> emit) async {
    emit(
      const AuthState(
        status: AuthStatus.unauthentcated,
        accessToken: null,
      ),
    );
  }

  Future<void> _onSetSessionFromDeepLink(
    AuthEvent_SetSessionFromDeepLink event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final accessToken =
          await _authRepository.setSessionFromUri(uri: event.uri);

      emit(
        AuthState(
          status: AuthStatus.authenticated,
          accessToken: accessToken,
        ),
      );

      event.completer.complete();
    } catch (_) {
      event.completer.completeError(
        Exception('AuthBloc: Could not set session from deep link'),
      );
    }
  }
}
