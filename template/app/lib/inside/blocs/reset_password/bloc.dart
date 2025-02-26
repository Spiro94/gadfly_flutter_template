import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../outside/repositories/auth/repository.dart';
import '../base.dart';
import 'events.dart';
import 'state.dart';

class ResetPassword_Bloc
    extends Bloc_Base<ResetPassword_Event, ResetPassword_State> {
  ResetPassword_Bloc({
    required Auth_Repository authRepository,
  })  : _authRepository = authRepository,
        super(
          const ResetPassword_State(
            status: ResetPassword_Status.idle,
            errorMessage: null,
            email: null,
          ),
        ) {
    on<ResetPassword_Event_SendResetPasswordLink>(
      _onSendResetPasswordLink,
      transformer: sequential(),
    );
    on<ResetPassword_Event_ResendResetPasswordLink>(
      _onResendResetPasswordLink,
      transformer: sequential(),
    );
    on<ResetPassword_Event_ResetPassword>(
      _onResetPassword,
      transformer: sequential(),
    );
  }

  final Auth_Repository _authRepository;

  Future<void> _onSendResetPasswordLink(
    ResetPassword_Event_SendResetPasswordLink event,
    Emitter<ResetPassword_State> emit,
  ) async {
    emit(
      state.copyWith(
        status: ResetPassword_Status.sendResetPasswordLinkInProgress,
      ),
    );
    try {
      final email = event.email.trim();
      await _authRepository.sendResetPasswordLink(
        email: email,
      );
      emit(
        state.copyWith(
          status: ResetPassword_Status.sendResetPasswordLinkSuccess,
          setEmail: () => email,
        ),
      );
    } catch (e, stackTrace) {
      log.warning('${event.runtimeType}: error', e, stackTrace);
      emit(
        state.copyWith(
          status: ResetPassword_Status.sendResetPasswordLinkError,
          setErrorMessage: e.toString,
        ),
      );
    } finally {
      emit(
        state.copyWith(
          status: ResetPassword_Status.idle,
          setErrorMessage: () => null,
          setEmail: () => null,
        ),
      );
    }
  }

  Future<void> _onResendResetPasswordLink(
    ResetPassword_Event_ResendResetPasswordLink event,
    Emitter<ResetPassword_State> emit,
  ) async {
    emit(
      state.copyWith(
        status: ResetPassword_Status.resendResetPasswordLinkInProgress,
      ),
    );
    try {
      final email = event.email.trim();
      await _authRepository.sendResetPasswordLink(
        email: email,
      );
      emit(
        state.copyWith(
          status: ResetPassword_Status.resendResetPasswordLinkSuccess,
          setEmail: () => email,
        ),
      );
    } catch (e, stackTrace) {
      log.warning('${event.runtimeType}: error', e, stackTrace);
      emit(
        state.copyWith(
          status: ResetPassword_Status.resendResetPasswordLinkError,
          setErrorMessage: e.toString,
        ),
      );
    } finally {
      emit(
        state.copyWith(
          status: ResetPassword_Status.idle,
          setErrorMessage: () => null,
          setEmail: () => null,
        ),
      );
    }
  }

  Future<void> _onResetPassword(
    ResetPassword_Event_ResetPassword event,
    Emitter<ResetPassword_State> emit,
  ) async {
    emit(
      state.copyWith(
        status: ResetPassword_Status.resetPasswordInProgress,
      ),
    );
    try {
      final password = event.password;
      await _authRepository.resetPassword(
        password: password,
      );
      emit(
        state.copyWith(
          status: ResetPassword_Status.resetPasswordSuccess,
        ),
      );
    } catch (e, stackTrace) {
      log.warning('${event.runtimeType}: error', e, stackTrace);
      emit(
        state.copyWith(
          status: ResetPassword_Status.resetPasswordError,
          setErrorMessage: e.toString,
        ),
      );
    } finally {
      emit(
        state.copyWith(
          status: ResetPassword_Status.idle,
          setErrorMessage: () => null,
          setEmail: () => null,
        ),
      );
    }
  }
}
