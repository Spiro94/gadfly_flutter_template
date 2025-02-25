import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../external/repositories/auth/repository.dart';
import '../../../shared/mixins/logging.dart';
import '../base_class.dart';
import 'events.dart';
import 'state.dart';

class AuthBloc extends Base_Bloc<AuthEvent, AuthState>
    with SharedMixin_Logging {
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
    on<AuthEvent_GetAccessTokenFromUri>(
      _getAccessTokenFromUri,
      transformer: sequential(),
    );
  }

  final AuthRepository _authRepository;

  Future<void> _onSignOut(
    AuthEvent_SignOut event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.signOut();
    } catch (e, stackTrace) {
      log.warning('${event.runtimeType}: error', e, stackTrace);
    } finally {
      await _tokenRemoved(emit);
    }
  }

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

    try {
      await _authRepository.updatesUsersInClients();
    } catch (e) {
      log.warning(e);
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

    try {
      await _authRepository.updatesUsersInClients();
    } catch (e) {
      log.warning(e);
    }
  }

  Future<void> _getAccessTokenFromUri(
    AuthEvent_GetAccessTokenFromUri event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final accessToken = await _authRepository.getAccessTokenFromUri(
        uri: event.uri,
        code: event.code,
        refreshToken: event.refreshToken,
      );

      emit(
        AuthState(
          status: AuthStatus.authenticated,
          accessToken: accessToken,
        ),
      );
      log.info('authenticated from URI');
      event.errorMessageCompleter.complete();
    } catch (e) {
      log.warning(e);

      // The redirect link after sign up seems to always be in this state, but
      // it doesn' affect the user, so we are ignoring this error.
      if (e is supabase.AuthException && e.code == 'flow_state_not_found') {
        event.errorMessageCompleter.complete();
        return;
      }

      event.errorMessageCompleter.complete(e.toString());
    }
  }
}
