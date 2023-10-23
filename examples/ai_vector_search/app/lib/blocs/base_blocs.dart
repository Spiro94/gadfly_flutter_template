import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth/event.dart';
import 'auth/state.dart';
import 'forgot_password/event.dart';
import 'forgot_password/state.dart';
// ATTENTION 1/2
import 'search/event.dart';
import 'search/state.dart';
// ---
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

// ATTENTION 2/2
class SearchBaseBloc extends AppBaseBloc<SearchEvent, SearchState> {
  SearchBaseBloc(super.initialState);
}
// ---
