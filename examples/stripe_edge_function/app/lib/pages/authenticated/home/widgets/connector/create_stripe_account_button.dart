import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/payments/bloc.dart';
import '../../../../../blocs/payments/event.dart';
import '../../../../../blocs/payments/state.dart';
import '../../../../../i18n/translations.g.dart';
import '../../../../../shared/widgets/dumb/button.dart';

class HomeC_CreateStripeAccountButton extends StatelessWidget {
  const HomeC_CreateStripeAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentsBloc = context.watch<PaymentsBloc>();

    return paymentsBloc.state.accountId != null &&
            paymentsBloc.state.accountId!.isNotEmpty
        ? Text(
            context.t.home.stripeId(stripeId: paymentsBloc.state.accountId!),
          )
        : SharedD_Button(
            label: context.t.home.createStripeAccount,
            status: paymentsBloc.state.status == PaymentsStatus.loading
                ? SharedD_Button_Status.loading
                : SharedD_Button_Status.enabled,
            onPressed: () {
              paymentsBloc.add(PaymentsEvent_CreatePaymentAccount());
            },
          );
  }
}
