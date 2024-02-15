import 'bootstrap.dart';
import 'configuration.dart';

void main() async {
  final configuration = MainConfigurations.developmentAndSendEvents;

  await bootstrap(configuration: configuration);
}
