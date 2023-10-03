import 'package:hello_world/effects/now/effect.dart';

class FakeNowEffect implements NowEffect {
  FakeNowEffect({
    this.initialTime,
  });

  final DateTime? initialTime;

  int secondsPassed = 0;

  @override
  DateTime now() {
    final now = (initialTime ?? DateTime.fromMillisecondsSinceEpoch(0).toUtc())
        .add(Duration(seconds: secondsPassed));

    secondsPassed++;

    return now;
  }
}
