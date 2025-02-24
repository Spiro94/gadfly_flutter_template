import 'dart:async';

import 'package:devtools_app_shared/ui.dart' as dui;
import 'package:devtools_extensions/devtools_extensions.dart' as de;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/extension/bloc.dart';
import 'blocs/extension/events.dart';
import 'models/bloc_event_payload.dart';
import 'models/json_filter.dart';
import 'models/log_filter.dart';
import 'widgets/left_pane.dart';
import 'widgets/right_pane.dart';

void main() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    BlocProvider(
      create: (context) => ExtensionBloc(sharedPreferences: sharedPreferences),
      child: BDEBlocDevtoolsExtension(
        sharedPreferences: sharedPreferences,
      ),
    ),
  );
}

class BDEBlocDevtoolsExtension extends StatefulWidget {
  const BDEBlocDevtoolsExtension({
    required this.sharedPreferences,
    super.key,
  });

  final SharedPreferences sharedPreferences;

  @override
  State<BDEBlocDevtoolsExtension> createState() =>
      _BDEBlocDevtoolsExtensionState();
}

class _BDEBlocDevtoolsExtensionState extends State<BDEBlocDevtoolsExtension> {
  //
  // ignore: strict_raw_type
  late StreamSubscription extensionEventSubscription;

  final _autoScrollController = AutoScrollController();

  @override
  void initState() {
    super.initState();

    final storedLogFilter = widget.sharedPreferences.getString('logFilter');
    if (storedLogFilter != null) {
      final selectedLogFilter = BDELogFilter.values.firstWhere(
        (filter) => filter.name == storedLogFilter,
        orElse: () => BDELogFilter.all,
      );

      context.read<ExtensionBloc>().add(
            ExtensionEvent_SetSelectedLogFilter(
              selectedLogFilter: selectedLogFilter,
            ),
          );
    }

    final storedJsonFilter = widget.sharedPreferences.getString('jsonFilter');
    if (storedJsonFilter != null) {
      final selectedJsonFilter = BDEJsonFilter.values.firstWhere(
        (filter) => filter.name == storedJsonFilter,
        orElse: () => BDEJsonFilter.raw,
      );
      context.read<ExtensionBloc>().add(
            ExtensionEvent_SetSelectedJsonFilter(
              selectedJsonFilter: selectedJsonFilter,
            ),
          );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vmService = await de.serviceManager.onServiceAvailable;

      extensionEventSubscription = vmService.onExtensionEvent.listen((event) {
        //
        // ignore: use_build_context_synchronously
        final extensionBloc = context.read<ExtensionBloc>();
        switch (event.extensionKind) {
          case 'ext.bde_bloc_devtools.reset':
            extensionBloc.add(ExtensionEvent_Reset());
          case 'ext.bde_bloc_devtools.bloc_event':
            try {
              final extensionData = event.extensionData?.data;
              if (extensionData == null) break;
              final blocEventPayload =
                  BDEBlocEventPayload.fromJson(extensionData);

              extensionBloc.add(
                ExtensionEvent_AddBlocEvent(blocEventPayload: blocEventPayload),
              );
              break;
            } catch (_) {}
        }
      });
    });
  }

  @override
  void dispose() {
    extensionEventSubscription.cancel();
    _autoScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return de.DevToolsExtension(
      child: dui.SplitPane(
        initialFractions: const [0.3, 0.7],
        axis: Axis.horizontal,
        children: [
          LeftPane(autoScrollController: _autoScrollController),
          RightPane(
            onSetSelectedEventIndex: (index) {
              _autoScrollController.scrollToIndex(
                index,
                duration: const Duration(milliseconds: 300),
                preferPosition: AutoScrollPosition.middle,
              );
              context.read<ExtensionBloc>().add(
                    ExtensionEvent_SetSelectedEventIndex(
                      selectedEventIndex: index,
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}
