import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/custom_claims/repository.dart';
import '../base_blocs.dart';
import 'event.dart';
import 'state.dart';

// Reference: https://github.com/flutter/flutter/issues/69949
//
// There is a nasty bug in Flutter Web during development where `dispose` is NOT
// called on hot-restart. This has implications for us because we want to listen
// to a stream. When we hot-restart, our current stream will not be canceled and
// yet we listen to a new stream. So there is a leak with our original stream.
//
// If we store our [_subscription] in a static variable, then on hot-restart it
// will get replaced. We can then check if [_subscription] is null in our
// listener, and if it is, we can simply not handle the events. So during
// development, we are allowing multiple listeners to acrue, but only the most
// recent will handle events. Note: this problem does not exist in production
// and it does not exist in mobile (only development time on web).
//
// To make this work, look for HR1 and HR2.

class CustomClaimsBloc extends CustomClaimsBaseBloc {
  CustomClaimsBloc({
    required CustomClaimsRepository customClaimsRepository,
  })  : _customClaimsRepository = customClaimsRepository,
        super(
          const CustomClaimsState(
            lastUpdatedAt: null,
            appRoleClaim: null,
          ),
        ) {
    on<CustomClaimsEvent_Initialize>(
      _onInitialize,
      transformer: sequential(),
    );
    on<CustomClaimsEvent_Refresh>(
      _onRefresh,
      transformer: sequential(),
    );
  }

  final CustomClaimsRepository _customClaimsRepository;

  // ATTENTION: HR1
  static StreamSubscription<List<Map<String, dynamic>>>? _subscription;
  // ---

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }

  Future<void> _onInitialize(
    CustomClaimsEvent_Initialize event,
    Emitter<CustomClaimsState> emit,
  ) async {
    try {
      final stream =
          await _customClaimsRepository.getCustomClaimUpdatesStream();

      _subscription = stream.listen(
        (rows) {
          // ATTENTION: HR2
          if (_subscription == null) return;
          // --

          try {
            final updatedAtString =
                rows.map((row) => row['updated_at'] as String).toList().single;

            final updatedAt = DateTime.parse(updatedAtString);

            if (state.lastUpdatedAt == null ||
                updatedAt.isAfter(state.lastUpdatedAt!)) {
              add(CustomClaimsEvent_Refresh(lastUpdatedAt: updatedAt));
            }
          } catch (_) {}
        },
      );
    } catch (_) {}
  }

  Future<void> _onRefresh(
    CustomClaimsEvent_Refresh event,
    Emitter<CustomClaimsState> emit,
  ) async {
    try {
      await _customClaimsRepository.refreshAuthSession();
      final claims = await _customClaimsRepository.getMyClaims();
      final appRoleClaim = claims['app_role'] as String;

      emit(
        CustomClaimsState(
          lastUpdatedAt: event.lastUpdatedAt,
          appRoleClaim: appRoleClaim,
        ),
      );
    } catch (_) {}
  }
}
