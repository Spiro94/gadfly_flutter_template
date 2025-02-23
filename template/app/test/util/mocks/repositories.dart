import 'package:gadfly_flutter_template/external/repositories/auth/repository.dart';
import 'package:gadfly_flutter_template/external/repositories/base_class.dart';
import 'package:mocktail/mocktail.dart';

/// When you create a new client provider, make sure to add it here
List<Base_Repository> createMockClientProviders() => [
      MockAuthRepository(),
    ];

class MockAuthRepository extends Mock implements AuthRepository {}
