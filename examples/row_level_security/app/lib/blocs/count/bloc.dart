import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/count/repository.dart';
import '../base_blocs.dart';
import 'event.dart';
import 'state.dart';

class CountBloc extends CountBaseBloc {
  CountBloc({
    required CountRepository countRepository,
  })  : _countRepository = countRepository,
        super(
          const CountState(status: CountStatus.idle, count: 0),
        ) {
    on<CountEvent_Initialize>(
      _onInitialize,
      transformer: sequential(),
    );
    on<CountEvent_Increment>(
      _onIncrement,
      transformer: sequential(),
    );
    on<CountEvent_Decrement>(
      _onDecrement,
      transformer: sequential(),
    );
  }

  final CountRepository _countRepository;

  Future<void> _onInitialize(
    CountEvent_Initialize event,
    Emitter<CountState> emit,
  ) async {
    emit(
      state.copyWith(status: CountStatus.loading),
    );

    try {
      final count = await _countRepository.getCount();
      emit(
        state.copyWith(count: count),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CountStatus.error),
      );
    } finally {
      emit(
        state.copyWith(status: CountStatus.idle),
      );
    }
  }

  Future<void> _onIncrement(
    CountEvent_Increment event,
    Emitter<CountState> emit,
  ) async {
    emit(
      state.copyWith(status: CountStatus.loading),
    );

    try {
      final incrementedCount = await _countRepository.updateCount(
        newCount: state.count + 1,
      );
      emit(
        state.copyWith(count: incrementedCount),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CountStatus.error),
      );
    } finally {
      emit(
        state.copyWith(status: CountStatus.idle),
      );
    }
  }

  Future<void> _onDecrement(
    CountEvent_Decrement event,
    Emitter<CountState> emit,
  ) async {
    emit(
      state.copyWith(status: CountStatus.loading),
    );

    try {
      final decrementedCount = await _countRepository.updateCount(
        newCount: state.count - 1,
      );
      emit(
        state.copyWith(count: decrementedCount),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CountStatus.error),
      );
    } finally {
      emit(
        state.copyWith(status: CountStatus.idle),
      );
    }
  }
}
