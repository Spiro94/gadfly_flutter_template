import 'package:flow_test/flow_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class FTConfig<M> {
  FTConfig({
    this.device,
    this.printTesterLogs = true,
    this.createBlocObserver,
    required this.mockedApps,
    this.onListItemRegexes,
    this.onShortDescriptionRegex,
  });

  final bool printTesterLogs;
  final Device? device;
  FTBlocObserver<M> Function(FTMockedApp<M> mockedApp)? createBlocObserver;
  final List<FTMockedApp<M>> mockedApps;
  final List<FTOnRegexMatch>? onListItemRegexes;
  final FTOnRegexMatch? onShortDescriptionRegex;
}
