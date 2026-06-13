// coverage:ignore-file

import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../shared/mixins/logging.dart';
import '../../shared/models/bloc_devtools_extension_log_record.dart';

class Blocs_Observer extends BlocObserver with SharedMixin_Logging {
  Blocs_Observer() {
    _initializeLogger();
    developer.postEvent('ext.bde_bloc_devtools.reset', {});
  }

  final _devtoolsLogRecords = <SharedModel_BlocDevtoolsExtension_LogRecord>[];

  void _initializeLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      final yoLogRecord = SharedModel_BlocDevtoolsExtension_LogRecord(
        logRecord: record,
      );
      _devtoolsLogRecords.add(yoLogRecord);
    });
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log.severe('(${bloc.runtimeType}) error', error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    try {
      final blocName = bloc.runtimeType.toString();
      developer.postEvent('ext.bde_bloc_devtools.bloc_event', {
        'bloc_name': blocName,
        'bloc_state': jsonEncode(bloc.state),
        'event_name': '${blocName}_Created',
        'logs': jsonEncode(_devtoolsLogRecords),
      });
      _devtoolsLogRecords.clear();
    } catch (e) {}

    super.onCreate(bloc);
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    try {
      final blocName = bloc.runtimeType.toString();
      developer.postEvent('ext.bde_bloc_devtools.bloc_event', {
        'bloc_name': blocName,
        'bloc_state': jsonEncode(transition.nextState),
        'event_name': transition.event.runtimeType.toString(),
        'logs': jsonEncode(_devtoolsLogRecords),
      });
      _devtoolsLogRecords.clear();
    } catch (_) {}

    super.onTransition(bloc, transition);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    if (bloc is Cubit) {
      try {
        final blocName = bloc.runtimeType.toString();
        developer.postEvent('ext.bde_bloc_devtools.bloc_event', {
          'bloc_name': blocName,
          'bloc_state': jsonEncode(change.nextState),
          'event_name': '${blocName}_Changed',
          'logs': jsonEncode(_devtoolsLogRecords),
        });
        _devtoolsLogRecords.clear();
      } catch (_) {}
    }

    super.onChange(bloc, change);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    try {
      final blocName = bloc.runtimeType.toString();
      developer.postEvent('ext.bde_bloc_devtools.bloc_event', {
        'bloc_name': blocName,
        'bloc_state': null,
        'event_name': '${blocName}_Closed',
        'logs': jsonEncode(_devtoolsLogRecords),
      });
      _devtoolsLogRecords.clear();
    } catch (_) {}

    super.onClose(bloc);
  }
}
