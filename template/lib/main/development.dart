import 'bootstrap.dart';
import 'configuration.dart';

void main() async {
  final configuration = MainConfigurations.development;

  await bootstrap(configuration: configuration);
}
