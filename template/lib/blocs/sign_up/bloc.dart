import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import '../../repositories/auth/repository.dart';
import '../base_blocs.dart';
import 'event.dart';
import 'state.dart';

class SignUpBloc extends SignUpBaseBloc {
  SignUpBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(
          const SignUpState(status: SignUpStatus.idle),
        ) {
    on<SignUpEvent_SignUp>(
      _onSignUp,
      transformer: sequential(),
    );
  }

  final AuthRepository _authRepository;
  final _log = Logger('sign_up_bloc');

  Future<void> _onSignUp(
    SignUpEvent_SignUp event,
    Emitter<SignUpState> emit,
  ) async {
    emit(
      const SignUpState(status: SignUpStatus.loading),
    );

    try {
      final email = event.email.trim();
      final password = event.password.trim();

      await _authRepository.signUp(
        email: email,
        password: password,
      );
    } catch (e) {
      _log.fine(e);
      emit(
        const SignUpState(status: SignUpStatus.error),
      );
    } finally {
      emit(
        const SignUpState(status: SignUpStatus.idle),
      );
    }
  }
}
