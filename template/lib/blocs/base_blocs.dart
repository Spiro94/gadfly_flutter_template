import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth/event.dart';
import 'auth/state.dart';
import 'forgot_password/event.dart';
import 'forgot_password/state.dart';
import 'record_audio/event.dart';
import 'record_audio/state.dart';
import 'recordings/event.dart';
import 'recordings/state.dart';
import 'reset_password/event.dart';
import 'reset_password/state.dart';
import 'sign_in/event.dart';
import 'sign_in/state.dart';
import 'sign_up/event.dart';
import 'sign_up/state.dart';

sealed class AppBaseBloc<Event, State> extends Bloc<Event, State> {
  AppBaseBloc(super.initialState);
}

class AuthBaseBloc extends AppBaseBloc<AuthEvent, AuthState> {
  AuthBaseBloc(super.initialState);
}

class ForgotPasswordBaseBloc
    extends AppBaseBloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBaseBloc(super.initialState);
}

class RecordingsBaseBloc extends AppBaseBloc<RecordingsEvent, RecordingsState> {
  RecordingsBaseBloc(super.initialState);
}

class RecordAudioBaseBloc
    extends AppBaseBloc<RecordAudioEvent, RecordAudioState> {
  RecordAudioBaseBloc(super.initialState);
}

class ResetPasswordBaseBloc
    extends AppBaseBloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBaseBloc(super.initialState);
}

class SignInBaseBloc extends AppBaseBloc<SignInEvent, SignInState> {
  SignInBaseBloc(super.initialState);
}

class SignUpBaseBloc extends AppBaseBloc<SignUpEvent, SignUpState> {
  SignUpBaseBloc(super.initialState);
}
