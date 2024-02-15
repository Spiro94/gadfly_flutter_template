import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/payments/repository.dart';
import '../base_blocs.dart';
import 'event.dart';
import 'state.dart';

class PaymentsBloc extends PaymentsBaseBloc {
  PaymentsBloc({
    required PaymentsRepository paymentsRepository,
  })  : _paymentsRepository = paymentsRepository,
        super(
          const PaymentsState(
            accountId: null,
            status: PaymentsStatus.loading,
          ),
        ) {
    on<PaymentsEvent_Initialize>(
      _onInitialize,
      transformer: sequential(),
    );
    on<PaymentsEvent_CreatePaymentAccount>(
      _onCreatePaymentAccount,
      transformer: sequential(),
    );
  }

  final PaymentsRepository _paymentsRepository;

  Future<void> _onInitialize(
    PaymentsEvent_Initialize event,
    Emitter<PaymentsState> emit,
  ) async {
    emit(
      state.copyWith(status: PaymentsStatus.loading),
    );

    try {
      if (state.accountId == null || state.accountId!.isEmpty) {
        final stripeId = await _paymentsRepository.getAccountId();
        if (stripeId != null && stripeId.isNotEmpty) {
          emit(
            state.copyWith(accountId: stripeId),
          );
        }
      }
    } catch (e) {
      emit(
        state.copyWith(status: PaymentsStatus.error),
      );
    } finally {
      emit(
        state.copyWith(status: PaymentsStatus.idle),
      );
    }
  }

  Future<void> _onCreatePaymentAccount(
    PaymentsEvent_CreatePaymentAccount event,
    Emitter<PaymentsState> emit,
  ) async {
    emit(
      state.copyWith(status: PaymentsStatus.loading),
    );

    try {
      if (state.accountId == null || state.accountId!.isEmpty) {
        final stripeId = await _paymentsRepository.createStripeAccount();
        emit(
          state.copyWith(accountId: stripeId),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: PaymentsStatus.error),
      );
    } finally {
      emit(
        state.copyWith(status: PaymentsStatus.idle),
      );
    }
  }
}
