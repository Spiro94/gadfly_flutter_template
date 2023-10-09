import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth/event.dart';
import 'auth/state.dart';
import 'forgot_password/event.dart';
import 'forgot_password/state.dart';
import 'payments/event.dart';
import 'payments/state.dart';
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

class SignInBaseBloc extends AppBaseBloc<SignInEvent, SignInState> {
  SignInBaseBloc(super.initialState);
}

class SignUpBaseBloc extends AppBaseBloc<SignUpEvent, SignUpState> {
  SignUpBaseBloc(super.initialState);
}

class PaymentsBaseBloc extends AppBaseBloc<PaymentsEvent, PaymentsState> {
  PaymentsBaseBloc(super.initialState);
}
