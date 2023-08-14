import 'package:gadfly_flutter_template/effects/now/effect.dart';

class FakeNowEffect implements NowEffect {
  @override
  DateTime now() {
    return DateTime.fromMillisecondsSinceEpoch(0).toUtc();
  }
}
