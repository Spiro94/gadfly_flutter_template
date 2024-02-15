import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/count/bloc.dart';

class HomeC_CounterText extends StatelessWidget {
  const HomeC_CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final countBloc = context.watch<CountBloc>();
    final count = countBloc.state.count;

    return Text(count.toString());
  }
}
