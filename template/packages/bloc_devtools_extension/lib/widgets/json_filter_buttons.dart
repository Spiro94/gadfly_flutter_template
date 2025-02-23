import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/extension/bloc.dart';
import '../blocs/extension/events.dart';
import '../models/json_filter.dart';

class JsonFilterButtons extends StatelessWidget {
  const JsonFilterButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedJsonFilter =
        context.select((ExtensionBloc bloc) => bloc.state.selectedJsonFilter);

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final filter in BDEJsonFilter.values)
          OutlinedButton(
            onPressed: () {
              context.read<ExtensionBloc>().add(
                    ExtensionEvent_SetSelectedJsonFilter(
                        selectedJsonFilter: filter,),
                  );
            },
            style: selectedJsonFilter == filter
                ? OutlinedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.teal),
                  )
                : null,
            child: Text(filter.name),
          ),
      ],
    );
  }
}
