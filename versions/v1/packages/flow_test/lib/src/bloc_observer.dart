import 'package:bloc/bloc.dart';
import 'package:flow_test/src/mocked_app.dart';

/// {@template ftBlocObserver}
/// This is our version of a [BlocObserver]. It adds [FTMockedApp.events], so we
/// can sniff the bloc events that get fired. It also adds an [init] method
/// which you can overwrite if you need to perform some setup with your bloc
/// observer.
/// {@endtemplate}
class FTBlocObserver<M> extends BlocObserver {
  /// {macro ftBlocObserver}
  FTBlocObserver({required this.mockedApp});

  /// A reference to the mocked app
  final FTMockedApp<M> mockedApp;

  /// A stub method that can be overwritten if needed.
  Future<void> init() async {}

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);

    /// Since cubits don't have events, we can still record when cubits are used
    /// by inserting the cubit's type to the [events] list.
    if (bloc is Cubit) {
      mockedApp.events.add(bloc.runtimeType);
    }
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);

    /// Add each bloc event to the [events] list.
    mockedApp.events.add(event.runtimeType);
  }
}
