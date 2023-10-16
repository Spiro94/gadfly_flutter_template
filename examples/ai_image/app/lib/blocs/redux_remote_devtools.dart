// ignore_for_file: depend_on_referenced_packages
import 'dart:async';

import 'package:json_annotation/json_annotation.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:redux_remote_devtools/redux_remote_devtools.dart';

import 'auth/state.dart';
import 'base_blocs.dart';
import 'forgot_password/state.dart';
// ATTENTION 1/8
import 'image_generation/state.dart';
// ---
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
    this.signInState,
    this.signUpState,
    // ATTENTON 2/8
    this.imageGenerationState,
    // ---
  });

  final AuthState? authState;
  final ForgotPasswordState? forgotPasswordState;
  final SignInState? signInState;
  final SignUpState? signUpState;
  // ATTENTION 3/8
  final ImageGenerationState? imageGenerationState;
  // ---

  DevtoolsDb copyWith({
    AuthState? authState,
    bool clearAuthState = false,
    ForgotPasswordState? forgotPasswordState,
    bool clearForgotPasswordState = false,
    SignInState? signInState,
    bool clearSignInState = false,
    SignUpState? signUpState,
    bool clearSignUpState = false,
    // ATTENTION 4/8
    ImageGenerationState? imageGenerationState,
    bool clearImageGenerationState = false,
    // ---
  }) {
    return DevtoolsDb(
      authState: clearAuthState ? null : authState ?? this.authState,
      forgotPasswordState: clearForgotPasswordState
          ? null
          : forgotPasswordState ?? this.forgotPasswordState,
      signInState: clearSignInState ? null : signInState ?? this.signInState,
      signUpState: clearSignUpState ? null : signUpState ?? this.signUpState,
      // ATTENTION 5/8
      imageGenerationState: clearImageGenerationState
          ? null
          : imageGenerationState ?? this.imageGenerationState,
      // ---
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
        devtoolsDb = devtoolsDb.copyWith(authState: bloc.state);

      case ForgotPasswordBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(forgotPasswordState: bloc.state);

      case SignInBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(signInState: bloc.state);

      case SignUpBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(signUpState: bloc.state);

      // ATTENTION 6/8
      case ImageGenerationBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(imageGenerationState: bloc.state);
      // ---
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
        devtoolsDb = devtoolsDb.copyWith(authState: state as AuthState);

      case ForgotPasswordBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(
          forgotPasswordState: state as ForgotPasswordState,
        );

      case SignInBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(signInState: state as SignInState);

      case SignUpBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(signUpState: state as SignUpState);

      // ATTENTION 7/8
      case ImageGenerationBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(
          imageGenerationState: state as ImageGenerationState,
        );
      // ---
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
        devtoolsDb = devtoolsDb.copyWith(clearAuthState: true);

      case ForgotPasswordBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(clearForgotPasswordState: true);

      case SignInBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(clearSignInState: true);

      case SignUpBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(clearSignUpState: true);

      // ATTENTION 8/8
      case ImageGenerationBaseBloc():
        devtoolsDb = devtoolsDb.copyWith(clearImageGenerationState: true);
    }
    // ---

    remoteReduxDevtoolsStore?.dispatch('DisposeBloc_${bloc.runtimeType}');
  }
}

Future<void> createReduxRemoteDevtoolsStore() async {
  final _devtools = RemoteDevToolsMiddleware<DevtoolsDb>('localhost:8001');

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
