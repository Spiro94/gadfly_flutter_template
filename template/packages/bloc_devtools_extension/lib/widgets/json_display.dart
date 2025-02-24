import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_diff/json_diff.dart' as jd;
import 'package:json_view/json_view.dart' as jv;
import '../blocs/extension/bloc.dart';

import '../models/json_filter.dart';
import 'diff_node_to_flutter.dart';

class JsonDisplay extends StatelessWidget {
  const JsonDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final events = context.select((ExtensionBloc bloc) => bloc.state.events);
    final effectiveEventIndex =
        context.select((ExtensionBloc bloc) => bloc.state.effectiveEventIndex);
    final selectedJsonFilter =
        context.select((ExtensionBloc bloc) => bloc.state.selectedJsonFilter);

    if (effectiveEventIndex == -1) {
      return const SizedBox();
    }

    switch (selectedJsonFilter) {
      case BDEJsonFilter.diff:
        return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: diffNodeToFlutter(
              jd.JsonDiffer.fromJson(
                events[effectiveEventIndex].previousAppState,
                events[effectiveEventIndex].currentAppState,
              ).diff(),
            ),);
      case BDEJsonFilter.tree:
        return jv.JsonView(
          json: events[effectiveEventIndex].currentAppState,
          shrinkWrap: true,
        );
      case BDEJsonFilter.raw:
        return rawJson(
          jsonEncode(events[effectiveEventIndex].currentAppState),
        );
    }
  }
}
