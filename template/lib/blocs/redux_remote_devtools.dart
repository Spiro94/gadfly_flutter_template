// ignore_for_file: depend_on_referenced_packages
import 'dart:async';

import 'package:json_annotation/json_annotation.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:redux_remote_devtools/redux_remote_devtools.dart';

import 'auth/state.dart';
import 'base_blocs.dart';
import 'forgot_password/state.dart';
import 'record_audio/state.dart';
import 'recordings/state.dart';
import 'reset_password/state.dart';
import 'sign_in/state.dart';
import 'sign_up/state.dart';

part 'redux_remote_devtools.g.dart';

DevToolsStore<DevtoolsDb>? remoteReduxDevtoolsStore;
DevtoolsDb devtoolsDb = const DevtoolsDb();

@JsonSerializable()
class DevtoolsDb {
  const DevtoolsDb({
    this.authState,
    this.forgotPasswordState,
    this.recordingsState,
    this.recordAudioState,
    this.resetPasswordState,
    this.signInState,
    this.signUpState,
  });

  final AuthState? authState;
  final ForgotPasswordState? forgotPasswordState;
  final RecordingsState? recordingsState;
  final RecordAudioState? recordAudioState;
  final ResetPasswordState? resetPasswordState;
  final SignInState? signInState;
  final SignUpState? signUpState;

  DevtoolsDb copyWith({
    AuthState? Function()? setAuthState,
    ForgotPasswordState? Function()? setForgotPasswordState,
    RecordingsState? Function()? setRecordingsState,
    RecordAudioState? Function()? setRecordAudioState,
    ResetPasswordState? Function()? setResetPasswordState,
    SignInState? Function()? setSignInState,
    SignUpState? Function()? setSignUpState,
  }) {
    return DevtoolsDb(
      authState: setAuthState?.call() ?? authState,
      forgotPasswordState:
          setForgotPasswordState?.call() ?? forgotPasswordState,
      recordingsState: setRecordingsState?.call() ?? recordingsState,
      recordAudioState: setRecordAudioState?.call() ?? recordAudioState,
      resetPasswordState: setResetPasswordState?.call() ?? resetPasswordState,
      signInState: setSignInState?.call() ?? signInState,
      signUpState: setSignUpState?.call() ?? signUpState,
    );
  }

  // coverage:ignore-start
  factory DevtoolsDb.fromJson(Map<String, dynamic> json) =>
      _$DevtoolsDbFromJson(json);

  Map<String, dynamic> toJson() => _$DevtoolsDbToJson(this);
  // coverage:ignore-end
}

void remoteReduxDevtoolsOnCreate({
  required AppBaseBloc<dynamic, dynamic> bloc,
}) {
  if (remoteReduxDevtoolsStore != null) {
    switch (bloc) {
      case AuthBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(setAuthState: () => bloc.state);

      case ForgotPasswordBaseBloc():
        devtoolsDb =
            devtoolsDb.copyWith(setForgotPasswordState: () => bloc.state);

      case RecordingsBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(setRecordingsState: () => bloc.state);

      case RecordAudioBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(setRecordAudioState: () => bloc.state);

      case ResetPasswordBaseBloc():
        devtoolsDb =
            devtoolsDb.copyWith(setResetPasswordState: () => bloc.state);

      case SignInBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(setSignInState: () => bloc.state);

      case SignUpBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(setSignUpState: () => bloc.state);
    }

    remoteReduxDevtoolsStore?.dispatch('CreateBloc_${bloc.runtimeType}');
  }
}

void remoteReduxDevtoolsOnTransition({
  required AppBaseBloc<dynamic, dynamic> bloc,
  required dynamic state,
  required dynamic event,
}) {
  if (remoteReduxDevtoolsStore != null) {
    switch (bloc) {
      case AuthBaseBloc():
        devtoolsDb =
            devtoolsDb.copyWith(setAuthState: () => state as AuthState);

      case ForgotPasswordBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(
          setForgotPasswordState: () => state as ForgotPasswordState,
        );

      case RecordingsBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(
          setRecordingsState: () => state as RecordingsState,
        );

      case RecordAudioBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(
          setRecordAudioState: () => state as RecordAudioState,
        );

      case ResetPasswordBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(
          setResetPasswordState: () => state as ResetPasswordState,
        );

      case SignInBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(
          setSignInState: () => state as SignInState,
        );

      case SignUpBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(
          setSignUpState: () => state as SignUpState,
        );
    }

    remoteReduxDevtoolsStore?.dispatch(event.runtimeType.toString());
  }
}

void remoteReduxDevtoolsOnClose({
  required AppBaseBloc<dynamic, dynamic> bloc,
}) {
  if (remoteReduxDevtoolsStore != null) {
    switch (bloc) {
      case AuthBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(setAuthState: () => null);

      case ForgotPasswordBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(setForgotPasswordState: () => null);

      case RecordingsBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(setRecordingsState: () => null);

      case RecordAudioBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(setRecordAudioState: () => null);

      case ResetPasswordBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(setResetPasswordState: () => null);

      case SignInBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(setSignInState: () => null);

      case SignUpBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(setSignUpState: () => null);
    }

    remoteReduxDevtoolsStore?.dispatch('DisposeBloc_${bloc.runtimeType}');
  }
}

Future<void> createReduxRemoteDevtoolsStore({
  required String appLocalhost,
}) async {
  final _devtools = RemoteDevToolsMiddleware<DevtoolsDb>('$appLocalhost:8001');

  await runZonedGuarded(
    () async {
      await _devtools.connect();
    },
    (_, __) {},
  );

  final store = DevToolsStore<DevtoolsDb>(
    (_, __) => devtoolsDb,
    initialState: devtoolsDb,
    middleware: <Middleware<DevtoolsDb>>[
      _devtools.call,
    ],
  );

  _devtools.store = store;
  remoteReduxDevtoolsStore = store;
}
