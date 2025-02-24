import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_change/provider.dart';
import 'base_class.dart';
import 'mixpanel/provider.dart';

/// When adding a new effect provider, be sure to add it to:
/// - [_list]
/// - [createProviders]
///   - Make sure to add the concrete type to `RepositoryProvider<ConcreteType>`
///     otherwise it will register the base class.
class AllEffectProviders {
  const AllEffectProviders({
    required this.authChangeEffectProvider,
    required this.mixpanelEffectProvider,
  });

  final AuthChangeEffectProvider authChangeEffectProvider;
  final MixpanelEffectProvider mixpanelEffectProvider;

  List<Base_EffectProvider<dynamic>> get _list => [
        authChangeEffectProvider,
        mixpanelEffectProvider,
      ];

  List<RepositoryProvider<Base_EffectProvider<dynamic>>> createProviders() {
    return [
      RepositoryProvider<AuthChangeEffectProvider>.value(
        value: authChangeEffectProvider,
      ),
      RepositoryProvider<MixpanelEffectProvider>.value(
        value: mixpanelEffectProvider,
      ),
    ];
  }

  Future<void> initialize() async {
    await Future.forEach(_list, (r) async {
      r.log.fine('init');
      await r.init();
    });
  }
}
