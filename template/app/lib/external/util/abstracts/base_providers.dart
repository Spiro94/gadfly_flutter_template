import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/builder.dart';
import '../../../app/runner.dart';

import 'base_provider.dart';

/// As a convenience in [appRunner] and [appBuilder], we package up our external
/// providers in a single class. The [getList] method is used to initialize the
/// providers in [appRunner]. The [createProviders] method is used in
/// [appBuilder].
abstract class ExternalUtilAbstract_BaseProviders {
  const ExternalUtilAbstract_BaseProviders();

  List<ExternalUtilAbstract_BaseProvider> getList();

  List<RepositoryProvider<ExternalUtilAbstract_BaseProvider>> createProviders();

  Future<void> initialize() async {
    await Future.forEach(getList(), (r) async {
      r.log.fine('init');
      await r.init();
    });
  }
}
