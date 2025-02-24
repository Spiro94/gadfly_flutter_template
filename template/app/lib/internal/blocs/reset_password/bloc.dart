import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../external/repositories/auth/repository.dart';
import '../base_class.dart';
import 'events.dart';
import 'state.dart';

class ResetPasswordBloc
    extends Base_Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(
          const ResetPasswordState(
            status: ResetPasswordStatus.idle,
            errorMessage: null,
            email: null,
          ),
        ) {
    on<ResetPasswordEvent_SendResetPasswordLink>(
      _onSendResetPasswordLink,
      transformer: sequential(),
    );
    on<ResetPasswordEvent_ResendResetPasswordLink>(
      _onResendResetPasswordLink,
      transformer: sequential(),
    );
    on<ResetPasswordEvent_ResetPassword>(
      _onResetPassword,
      transformer: sequential(),
    );
  }

  final AuthRepository _authRepository;

  Future<void> _onSendResetPasswordLink(
    ResetPasswordEvent_SendResetPasswordLink event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ResetPasswordStatus.sendResetPasswordLinkInProgress,
      ),
    );
    try {
      final email = event.email.trim();
      await _authRepository.sendResetPasswordLink(
        email: email,
      );
      emit(
        state.copyWith(
          status: ResetPasswordStatus.sendResetPasswordLinkSuccess,
          setEmail: () => email,
        ),
      );
    } catch (e, stackTrace) {
      log.warning('${event.runtimeType}: error', e, stackTrace);
      emit(
        state.copyWith(
          status: ResetPasswordStatus.sendResetPasswordLinkError,
          setErrorMessage: e.toString,
        ),
      );
    } finally {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.idle,
          setErrorMessage: () => null,
          setEmail: () => null,
        ),
      );
    }
  }

  Future<void> _onResendResetPasswordLink(
    ResetPasswordEvent_ResendResetPasswordLink event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ResetPasswordStatus.resendResetPasswordLinkInProgress,
      ),
    );
    try {
      final email = event.email.trim();
      await _authRepository.sendResetPasswordLink(
        email: email,
      );
      emit(
        state.copyWith(
          status: ResetPasswordStatus.resendResetPasswordLinkSuccess,
          setEmail: () => email,
        ),
      );
    } catch (e, stackTrace) {
      log.warning('${event.runtimeType}: error', e, stackTrace);
      emit(
        state.copyWith(
          status: ResetPasswordStatus.resendResetPasswordLinkError,
          setErrorMessage: e.toString,
        ),
      );
    } finally {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.idle,
          setErrorMessage: () => null,
          setEmail: () => null,
        ),
      );
    }
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent_ResetPassword event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ResetPasswordStatus.resetPasswordInProgress,
      ),
    );
    try {
      final password = event.password;
      await _authRepository.resetPassword(
        password: password,
      );
      emit(
        state.copyWith(
          status: ResetPasswordStatus.resetPasswordSuccess,
        ),
      );
    } catch (e, stackTrace) {
      log.warning('${event.runtimeType}: error', e, stackTrace);
      emit(
        state.copyWith(
          status: ResetPasswordStatus.resetPasswordError,
          setErrorMessage: e.toString,
        ),
      );
    } finally {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.idle,
          setErrorMessage: () => null,
          setEmail: () => null,
        ),
      );
    }
  }
}
