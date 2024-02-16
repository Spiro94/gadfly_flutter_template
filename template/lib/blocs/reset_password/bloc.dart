import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth/repository.dart';
import '../base_blocs.dart';
import 'event.dart';
import 'state.dart';

class ResetPasswordBloc extends ResetPasswordBaseBloc {
  ResetPasswordBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(
          const ResetPasswordState(
            status: ResetPasswordStatus.idle,
          ),
        ) {
    on<ResetPasswordEvent_ResetPassword>(
      _onResetPassword,
      transformer: sequential(),
    );
  }

  final AuthRepository _authRepository;

  Future<void> _onResetPassword(
    ResetPasswordEvent_ResetPassword event,
    Emitter<ResetPasswordState> emit,
  ) async {
    try {
      emit(const ResetPasswordState(status: ResetPasswordStatus.loading));

      final newPassword = event.password.trim();
      await _authRepository.resetPassword(password: newPassword);

      emit(const ResetPasswordState(status: ResetPasswordStatus.success));
    } catch (_) {
      emit(const ResetPasswordState(status: ResetPasswordStatus.error));
    } finally {
      emit(const ResetPasswordState(status: ResetPasswordStatus.idle));
    }
  }
}
