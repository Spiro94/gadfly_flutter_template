import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import '../../repositories/auth/repository.dart';
import '../base_blocs.dart';
import 'event.dart';
import 'state.dart';

class SignInBloc extends SignInBaseBloc {
  SignInBloc({
    required this.onSaveAccessToken,
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(
          const SignInState(status: SignInStatus.idle),
        ) {
    on<SignInEvent_SignIn>(
      _onSignIn,
      transformer: sequential(),
    );
  }

  final AuthRepository _authRepository;
  final void Function(String accessToken) onSaveAccessToken;
  final _log = Logger('sign_in_bloc');

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

      final accessToken = await _authRepository.signIn(
        email: email,
        password: password,
      );

      onSaveAccessToken(accessToken);
    } catch (e) {
      _log.fine(e);
      emit(
        const SignInState(status: SignInStatus.error),
      );
    } finally {
      emit(
        const SignInState(status: SignInStatus.idle),
      );
    }
  }
}
