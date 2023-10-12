import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth/repository.dart';
import '../base_blocs.dart';
import 'event.dart';
import 'state.dart';

class SignInBloc extends SignInBaseBloc {
  SignInBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(
          const SignInState(status: SignInStatus.idle),
        ) {
    on<SignInEvent_SignIn>(
      _onSignIn,
      transformer: sequential(),
    );
    // ATTENTION 1/2
    on<SignInEvent_SignInWithGoogle>(
      _onSignInWithGoogle,
      transformer: sequential(),
    );
    // ---
  }

  final AuthRepository _authRepository;

  Future<void> _onSignIn(
    SignInEvent_SignIn event,
    Emitter<SignInState> emit,
  ) async {
    emit(
      const SignInState(status: SignInStatus.loading),
    );

    try {
      final email = event.email.trim();
      final password = event.password.trim();

      await _authRepository.signIn(
        email: email,
        password: password,
      );
    } catch (e) {
      emit(
        const SignInState(status: SignInStatus.error),
      );
    } finally {
      emit(
        const SignInState(status: SignInStatus.idle),
      );
    }
  }

  // ATTENTION 2/2
  Future<void> _onSignInWithGoogle(
    SignInEvent_SignInWithGoogle event,
    Emitter<SignInState> emit,
  ) async {
    try {
      await _authRepository.signInWithGoogle();
    } catch (e) {
      emit(
        const SignInState(status: SignInStatus.error),
      );
    } finally {
      emit(
        const SignInState(status: SignInStatus.idle),
      );
    }
  }
  // ---
}
