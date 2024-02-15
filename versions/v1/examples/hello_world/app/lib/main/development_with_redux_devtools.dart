import 'bootstrap.dart';
import 'configuration.dart';

void main() async {
  final configuration = MainConfigurations.developmentWithReduxDevtools;

  await bootstrap(configuration: configuration);
}
