import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/repository.dart';
import 'base_class.dart';

/// When adding a new repository, be sure to add it to:
/// - [_list]
/// - [createProviders]
///   - Make sure to add the concrete type to `RepositoryProvider<ConcreteType>`
///     otherwise it will register the base class.
class AllRepositories {
  const AllRepositories({
    required this.authRepository,
  });

  final AuthRepository authRepository;

  List<Base_Repository> get _list => [
        authRepository,
      ];

  List<RepositoryProvider<Base_Repository>> createProviders() {
    return [
      RepositoryProvider<AuthRepository>.value(value: authRepository),
    ];
  }

  Future<void> initialize() async {
    await Future.forEach(_list, (r) async {
      r.log.fine('init');
      await r.init();
    });
  }
}
