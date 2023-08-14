import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import '../blocs/base_blocs.dart';
import '../blocs/redux_remote_devtools.dart';

class AppBlocObserver extends BlocObserver {
  final log = Logger('bloc_observer');

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    log.fine('[${bloc.runtimeType}] ${event.runtimeType}');

    super.onEvent(bloc, event);
  }

  @override
  void onError(
    BlocBase<dynamic> bloc,
    Object error,
    StackTrace stackTrace,
  ) {
    log.severe('[${bloc.runtimeType}] $error', error, stackTrace);

    super.onError(bloc, error, stackTrace);
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    remoteReduxDevtoolsOnCreate(bloc: bloc as AppBaseBloc);
    super.onCreate(bloc);
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    remoteReduxDevtoolsOnTransition(
      bloc: bloc as AppBaseBloc<dynamic, dynamic>,
      state: transition.nextState,
      event: transition.event,
    );
    super.onTransition(bloc, transition);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    remoteReduxDevtoolsOnClose(bloc: bloc as AppBaseBloc);
    super.onClose(bloc);
  }
}
