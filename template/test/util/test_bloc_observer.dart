import 'package:amplitude_repository/amplitude_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

/// A bloc observer for tests.
class TestBlocObserver extends BlocObserver {
  TestBlocObserver({
    required this.amplitudeRepository,
  });

  final AmplitudeRepository amplitudeRepository;

  final List<Object> _observedEvents = [];

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    _observedEvents.add(event.runtimeType);
    super.onEvent(bloc, event);
  }

  /// Returns all observed events and clears the list.
  List<Object> getAndResetObservedEvents() {
    final eventsToReturn = List<Object>.from(_observedEvents);
    _observedEvents.clear();
    return eventsToReturn;
  }

  Future<void> init() async {
    /// Track
    when(
      () => amplitudeRepository.track(
        event: any(named: 'event'),
        properties: any(named: 'properties'),
      ),
    ).thenAnswer((invocation) async {
      final name = invocation.namedArguments[const Symbol('event')];
      _observedEvents.add('Track: $name');
    });

    /// Page
    when(
      () => amplitudeRepository.page(
        event: any(named: 'event'),
        properties: any(named: 'properties'),
        popped: any(named: 'popped'),
      ),
    ).thenAnswer((invocation) async {
      final name = invocation.namedArguments[const Symbol('event')] as String;

      if (name.contains('_Routes')) {
        return;
      }

      final nameSanitized = name.replaceAll('_Route', '');
      if (invocation.namedArguments[const Symbol('popped')] as bool) {
        _observedEvents.add('Page popped: $nameSanitized');
      } else {
        _observedEvents.add('Page: $nameSanitized');
      }
    });
  }
}
