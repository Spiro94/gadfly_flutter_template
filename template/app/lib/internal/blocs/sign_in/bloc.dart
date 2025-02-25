import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../external/repositories/auth/repository.dart';
import '../base.dart';
import 'events.dart';
import 'state.dart';

class SignInBloc extends Blocs_Base<SignInEvent, SignInState> {
  SignInBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(
          const SignInState(
            status: SignInStatus.idle,
            errorMessage: null,
          ),
        ) {
    on<SignInEvent_SignIn>(_onSignIn, transformer: sequential());
  }

  final AuthRepository _authRepository;

  Future<void> _onSignIn(
    SignInEvent_SignIn event,
    Emitter<SignInState> emit,
  ) async {
    emit(state.copyWith(status: SignInStatus.signInInProgress));
    try {
      await _authRepository.signIn(
        email: event.email.trim(),
        password: event.password.trim(),
      );
      emit(state.copyWith(status: SignInStatus.signInSuccess));
    } catch (e, stackTrace) {
      log.warning('${event.runtimeType}: error', e, stackTrace);
      emit(
        state.copyWith(
          status: SignInStatus.signInError,
          setErrorMessage: e.toString,
        ),
      );
    } finally {
      emit(
        state.copyWith(
          status: SignInStatus.idle,
          setErrorMessage: () => null,
        ),
      );
    }
  }
}
