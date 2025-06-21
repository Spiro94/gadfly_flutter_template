import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../outside/repositories/auth/repository.dart';
import '../base.dart';
import 'events.dart';
import 'state.dart';

class Auth_Bloc extends Bloc_Base<Auth_Event, Auth_State> {
  Auth_Bloc({
    required Auth_Repository authRepository,
    required Auth_State initialState,
  })  : _authRepository = authRepository,
        super(initialState) {
    on<Auth_Event_SignOut>(
      _onSignOut,
      transformer: sequential(),
    );
    on<Auth_Event_AccessTokenAdded>(
      _onAccessTokenAdded,
      transformer: sequential(),
    );
    on<Auth_Event_AccessTokenRemoved>(
      _onAccessTokenRemoved,
      transformer: sequential(),
    );
    on<Auth_Event_GetAccessTokenFromUri>(
      _getAccessTokenFromUri,
      transformer: sequential(),
    );
  }

  final Auth_Repository _authRepository;

  Future<void> _onSignOut(
    Auth_Event_SignOut event,
    Emitter<Auth_State> emit,
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
    Auth_Event_AccessTokenAdded event,
    Emitter<Auth_State> emit,
  ) async {
    // TODO: validate token
    emit(
      Auth_State(
        status: Auth_Status.authenticated,
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
    Auth_Event_AccessTokenRemoved event,
    Emitter<Auth_State> emit,
  ) async {
    await _tokenRemoved(emit);
  }

  Future<void> _tokenRemoved(Emitter<Auth_State> emit) async {
    emit(
      const Auth_State(
        status: Auth_Status.unauthentcated,
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
    Auth_Event_GetAccessTokenFromUri event,
    Emitter<Auth_State> emit,
  ) async {
    try {
      final accessToken = await _authRepository.getAccessTokenFromUri(
        uri: event.uri,
        code: event.code,
        refreshToken: event.refreshToken,
      );

      emit(
        Auth_State(
          status: Auth_Status.authenticated,
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
