import 'bootstrap.dart';
import 'configuration.dart';

void main() async {
  final configuration = MainConfigurations.production;

  await bootstrap(configuration: configuration);
}
