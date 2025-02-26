import 'package:flutter_bloc/flutter_bloc.dart';

import '../util/abstracts/base_providers.dart';
import 'auth_change/provider.dart';
import 'base_class.dart';
import 'mixpanel/provider.dart';

/// When adding a new effect provider, be sure to add it to:
/// - [getList]
/// - [createProviders]
///   - Make sure to add the concrete type to `RepositoryProvider<ConcreteType>`
///     otherwise it will register the base class.
class AllEffectProviders extends OutsideUtilAbstract_BaseProviders {
  const AllEffectProviders({
    required this.authChangeEffectProvider,
    required this.mixpanelEffectProvider,
  });

  final AuthChangeEffectProvider authChangeEffectProvider;
  final MixpanelEffectProvider mixpanelEffectProvider;

  @override
  List<Base_EffectProvider<dynamic>> getList() => [
        authChangeEffectProvider,
        mixpanelEffectProvider,
      ];

  @override
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
}
