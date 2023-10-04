import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/count/bloc.dart';
import '../../../../../blocs/count/event.dart';
import '../../../../../i18n/translations.g.dart';

class HomeC_IncrementButton extends StatelessWidget {
  const HomeC_IncrementButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(
        context.t.home.increment,
      ),
      onPressed: () {
        final countBloc = context.read<CountBloc>();
        countBloc.add(CountEvent_Increment());
      },
    );
  }
}
