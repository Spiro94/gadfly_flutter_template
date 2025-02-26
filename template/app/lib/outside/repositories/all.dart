import 'package:flutter_bloc/flutter_bloc.dart';

import '../util/abstracts/base_provider.dart';
import '../util/abstracts/base_providers.dart';
import 'auth/repository.dart';

/// When adding a new repository, be sure to add it to:
/// - [getList]
/// - [createProviders]
///   - Make sure to add the concrete type to `RepositoryProvider<ConcreteType>`
///     otherwise it will register the base class.
class AllRepositories extends OutsideUtilAbstract_BaseProviders {
  const AllRepositories({
    required this.authRepository,
  });

  final AuthRepository authRepository;

  @override
  List<OutsideUtilAbstract_BaseProvider> getList() => [
        authRepository,
      ];

  @override
  List<RepositoryProvider<OutsideUtilAbstract_BaseProvider>> createProviders() {
    return [
      RepositoryProvider<AuthRepository>.value(value: authRepository),
    ];
  }
}
