import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import '../../repositories/auth/repository.dart';
import '../base_blocs.dart';
import 'event.dart';
import 'state.dart';

class ForgotPasswordBloc extends ForgotPasswordBaseBloc {
  ForgotPasswordBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(
          const ForgotPasswordState(
            status: ForgotPasswordStatus.idle,
            forgotPasswordEmail: null,
          ),
        ) {
    on<ForgotPasswordEvent_ForgotPassword>(
      _onForgotPassword,
      transformer: sequential(),
    );
    on<ForgotPasswordEvent_ResendForgotPassword>(
      _onResendForgotPassword,
      transformer: sequential(),
    );
  }

  final AuthRepository _authRepository;

  final _log = Logger('forgot_password_bloc');

  Future<void> _onForgotPassword(
    ForgotPasswordEvent_ForgotPassword event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    await _sendForgotPasswordEmail(
      emailRaw: event.email,
      successStatus: ForgotPasswordStatus.sendLinkSuccess,
      errorStatus: ForgotPasswordStatus.sendLinkError,
      emit: emit,
    );
  }

  Future<void> _onResendForgotPassword(
    ForgotPasswordEvent_ResendForgotPassword event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    await _sendForgotPasswordEmail(
      emailRaw: event.email,
      successStatus: ForgotPasswordStatus.resendLinkSuccess,
      errorStatus: ForgotPasswordStatus.resendLinkError,
      emit: emit,
    );
  }

  Future<void> _sendForgotPasswordEmail({
    required String emailRaw,
    required ForgotPasswordStatus successStatus,
    required ForgotPasswordStatus errorStatus,
    required Emitter<ForgotPasswordState> emit,
  }) async {
    emit(
      state.copyWith(
        status: ForgotPasswordStatus.loading,
        setForgotPasswordEmail: () {
          return null;
        },
      ),
    );

    try {
      final email = emailRaw.trim();

      await _authRepository.forgotPassword(
        email: email,
      );
      emit(
        state.copyWith(
          status: successStatus,
          setForgotPasswordEmail: () => email,
        ),
      );
    } catch (e) {
      _log.fine(e);
      emit(
        state.copyWith(
          status: errorStatus,
          setForgotPasswordEmail: () {
            return null;
          },
        ),
      );
    } finally {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.idle,
        ),
      );
    }
  }
}
