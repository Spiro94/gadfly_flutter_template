import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../external/repositories/auth/repository.dart';
import '../base_class.dart';
import 'events.dart';
import 'state.dart';

class SignUpBloc extends Base_Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(
          const SignUpState(
            status: SignUpStatus.idle,
            errorMessage: null,
          ),
        ) {
    on<SignUpEvent_SignUp>(
      _onSignUp,
      transformer: sequential(),
    );
    on<SignUpEvent_ResendEmailVerificationLink>(
      _onResendEmailVerificationLink,
      transformer: sequential(),
    );
  }

  final AuthRepository _authRepository;

  Future<void> _onSignUp(
    SignUpEvent_SignUp event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(status: SignUpStatus.signUpInProgress));
    try {
      await _authRepository.signUp(
        email: event.email.trim(),
        password: event.password.trim(),
      );
      emit(state.copyWith(status: SignUpStatus.signUpSuccess));
    } catch (e, stackTrace) {
      log.warning('${event.runtimeType}: error', e, stackTrace);
      emit(
        state.copyWith(
          status: SignUpStatus.signUpError,
          setErrorMessage: e.toString,
        ),
      );
    } finally {
      emit(
        state.copyWith(
          status: SignUpStatus.idle,
          setErrorMessage: () => null,
        ),
      );
    }
  }

  Future<void> _onResendEmailVerificationLink(
    SignUpEvent_ResendEmailVerificationLink event,
    Emitter<SignUpState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SignUpStatus.resendEmailVerificationLinkInProgress,
      ),
    );
    try {
      await _authRepository.resendEmailVerificationLink(
        email: event.email.trim(),
      );
      emit(
        state.copyWith(
          status: SignUpStatus.resendEmailVerificationLinkSuccess,
        ),
      );
    } catch (e, stackTrace) {
      log.warning('${event.runtimeType}: error', e, stackTrace);
      emit(
        state.copyWith(
          status: SignUpStatus.resendEmailVerificationLinkError,
          setErrorMessage: e.toString,
        ),
      );
    } finally {
      emit(
        state.copyWith(
          status: SignUpStatus.idle,
          setErrorMessage: () => null,
        ),
      );
    }
  }
}
