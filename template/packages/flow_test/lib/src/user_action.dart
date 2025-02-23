import 'package:flow_test/flow_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart' as ft;

class FTUserAction {
  FTUserAction({
    required ft.WidgetTester widgetTester,
    required List<FTUserActionRecord> userActionRecords,
  })  : _widgetTester = widgetTester,
        _userActionRecords = userActionRecords;

  final ft.WidgetTester _widgetTester;
  final List<FTUserActionRecord> _userActionRecords;

  Future<void> drag(
    ft.Finder finder,
    Offset offset, {
    int? pointer,
    int buttons = kPrimaryButton,
    double touchSlopX = ft.kDragSlopDefault,
    double touchSlopY = ft.kDragSlopDefault,
    bool warnIfMissed = true,
    PointerDeviceKind kind = PointerDeviceKind.touch,
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description:
            '''Dragged: ${finder.describeMatch(ft.Plurality.one)} by (x: ${offset.dx}, y: ${offset.dy})''',
      ),
    );
    await _widgetTester.drag(
      finder,
      offset,
      pointer: pointer,
      buttons: buttons,
      touchSlopX: touchSlopX,
      touchSlopY: touchSlopY,
      kind: kind,
    );
  }

  Future<void> dragFrom(
    Offset startLocation,
    Offset offset, {
    int? pointer,
    int buttons = kPrimaryButton,
    double touchSlopX = ft.kDragSlopDefault,
    double touchSlopY = ft.kDragSlopDefault,
    bool warnIfMissed = true,
    PointerDeviceKind kind = PointerDeviceKind.touch,
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description:
            '''Dragged from: (x: ${startLocation.dx}, y: ${startLocation.dy}) by (x: ${offset.dx}, y: ${offset.dy})''',
      ),
    );
    await _widgetTester.dragFrom(
      startLocation,
      offset,
      pointer: pointer,
      buttons: buttons,
      touchSlopX: touchSlopX,
      touchSlopY: touchSlopY,
      kind: kind,
    );
  }

  Future<void> dragUntilVisible(
    ft.Finder finder,
    ft.Finder view,
    Offset moveStep, {
    int maxIteration = 50,
    Duration duration = const Duration(milliseconds: 50),
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description:
            '''Dragged until visible: ${finder.describeMatch(ft.Plurality.one)} -> ${view.describeMatch(ft.Plurality.one)}''',
      ),
    );
    await _widgetTester.dragUntilVisible(
      finder,
      view,
      moveStep,
      maxIteration: maxIteration,
      duration: duration,
    );
  }

  Future<void> enterText(
    ft.Finder finder,
    String text,
  ) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description: '''Entered text: $text''',
      ),
    );
    await _widgetTester.enterText(
      finder,
      text,
    );
  }

  Future<void> fling(
    ft.Finder finder,
    Offset offset,
    double speed, {
    int? pointer,
    int buttons = kPrimaryButton,
    Duration frameInterval = const Duration(milliseconds: 16),
    Offset initialOffset = Offset.zero,
    Duration initialOffsetDelay = const Duration(seconds: 1),
    bool warnIfMissed = true,
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description:
            '''Flinged: ${finder.describeMatch(ft.Plurality.one)} by (x: ${offset.dx}, y: ${offset.dy})''',
      ),
    );
    await _widgetTester.fling(
      finder,
      offset,
      speed,
      pointer: pointer,
      buttons: buttons,
      frameInterval: frameInterval,
      initialOffset: initialOffset,
      initialOffsetDelay: initialOffsetDelay,
      warnIfMissed: warnIfMissed,
    );
  }

  Future<void> flingFrom(
    Offset startLocation,
    Offset offset,
    double speed, {
    int? pointer,
    int buttons = kPrimaryButton,
    Duration frameInterval = const Duration(milliseconds: 16),
    Offset initialOffset = Offset.zero,
    Duration initialOffsetDelay = const Duration(seconds: 1),
    bool warnIfMissed = true,
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description:
            '''Flinged from: (x: ${startLocation.dx}, y: ${startLocation.dy}) by (x: ${offset.dx}, y: ${offset.dy})''',
      ),
    );
    await _widgetTester.flingFrom(
      startLocation,
      offset,
      speed,
      pointer: pointer,
      buttons: buttons,
      frameInterval: frameInterval,
      initialOffset: initialOffset,
      initialOffsetDelay: initialOffsetDelay,
    );
  }

  Future<void> longPress(
    ft.Finder finder, {
    int? pointer,
    int buttons = kPrimaryButton,
    bool warnIfMissed = true,
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description:
            '''Long pressed: ${finder.describeMatch(ft.Plurality.one)}''',
      ),
    );
    await _widgetTester.longPress(
      finder,
      pointer: pointer,
      buttons: buttons,
      warnIfMissed: warnIfMissed,
    );
  }

  Future<void> longPressAt(
    Offset location, {
    int? pointer,
    int buttons = kPrimaryButton,
    bool warnIfMissed = true,
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description:
            '''Long pressed at: (x: ${location.dx}, y: ${location.dy})''',
      ),
    );
    await _widgetTester.longPressAt(
      location,
      pointer: pointer,
      buttons: buttons,
    );
  }

  Future<void> pageBack(
    ft.Finder finder, {
    int? pointer,
    int buttons = kPrimaryButton,
    bool warnIfMissed = true,
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description: '''Paged back''',
      ),
    );
    await _widgetTester.pageBack();
  }

  Future<void> press(
    ft.Finder finder, {
    int? pointer,
    int buttons = kPrimaryButton,
    bool warnIfMissed = true,
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description: '''Pressed: ${finder.describeMatch(ft.Plurality.one)}''',
      ),
    );
    await _widgetTester.press(
      finder,
      pointer: pointer,
      buttons: buttons,
      warnIfMissed: warnIfMissed,
    );
  }

  Future<void> scrollUntilVisible(
    ft.Finder finder,
    double delta, {
    ft.Finder? scrollable,
    int maxScrolls = 50,
    Duration duration = const Duration(milliseconds: 50),
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description:
            '''Scrolled until visible: ${finder.describeMatch(ft.Plurality.one)}''',
      ),
    );
    await _widgetTester.scrollUntilVisible(
      finder,
      delta,
      scrollable: scrollable,
      maxScrolls: maxScrolls,
      duration: duration,
    );
  }

  static const String _defaultPlatform = kIsWeb ? 'web' : 'android';
  Future<void> sendKeydownEvent(
    LogicalKeyboardKey key, {
    String platform = _defaultPlatform,
    String? character,
    PhysicalKeyboardKey? physicalKey,
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description: '''Sent key down event: ${key.debugName}''',
      ),
    );
    await _widgetTester.sendKeyDownEvent(
      key,
      platform: platform,
      character: character,
      physicalKey: physicalKey,
    );
  }

  Future<void> sendKeyEvent(
    LogicalKeyboardKey key, {
    String platform = _defaultPlatform,
    String? character,
    PhysicalKeyboardKey? physicalKey,
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description: '''Sent key event: ${key.debugName}''',
      ),
    );
    await _widgetTester.sendKeyEvent(
      key,
      platform: platform,
      character: character,
      physicalKey: physicalKey,
    );
  }

  Future<void> sendKeyRepeatEvent(
    LogicalKeyboardKey key, {
    String platform = _defaultPlatform,
    String? character,
    PhysicalKeyboardKey? physicalKey,
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description: '''Sent key repeat event: ${key.debugName}''',
      ),
    );
    await _widgetTester.sendKeyRepeatEvent(
      key,
      platform: platform,
      character: character,
      physicalKey: physicalKey,
    );
  }

  Future<void> sendKeyUpEvent(
    LogicalKeyboardKey key, {
    String platform = _defaultPlatform,
    String? character,
    PhysicalKeyboardKey? physicalKey,
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description: '''Sent key up event: ${key.debugName}''',
      ),
    );
    await _widgetTester.sendKeyUpEvent(
      key,
      platform: platform,
      physicalKey: physicalKey,
    );
  }

  Future<void> startGesture(
    Offset downLocation, {
    int? pointer,
    PointerDeviceKind kind = PointerDeviceKind.touch,
    int buttons = kPrimaryButton,
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description:
            '''Started gesture: (x: ${downLocation.dx} y: ${downLocation.dy})''',
      ),
    );
    await _widgetTester.startGesture(
      downLocation,
      pointer: pointer,
      kind: kind,
      buttons: buttons,
    );
  }

  Future<void> tap(
    ft.Finder finder, {
    int? pointer,
    int buttons = kPrimaryButton,
    bool warnIfMissed = true,
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description: 'Tapped: ${finder.describeMatch(ft.Plurality.one)}',
      ),
    );
    await _widgetTester.tap(
      finder,
      pointer: pointer,
      buttons: buttons,
      warnIfMissed: warnIfMissed,
    );
  }

  Future<void> tapAt(
    Offset location, {
    int? pointer,
    int buttons = kPrimaryButton,
    bool warnIfMissed = true,
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description: 'Tapped at: (x: ${location.dx}, y: ${location.dy})',
      ),
    );
    await _widgetTester.tapAt(
      location,
      pointer: pointer,
      buttons: buttons,
    );
  }

  Future<void> testTextInputEnterText(String text) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description: 'Entered text: $text',
      ),
    );
    return _widgetTester.testTextInput.enterText(text);
  }

  Future<void> testTextInputReceiveNext() async {
    _userActionRecords.add(
      FTUserActionRecord(
        description: 'Keyboard action: Next',
      ),
    );
    return _widgetTester.testTextInput.receiveAction(TextInputAction.next);
  }

  Future<void> testTextInputReceiveDone() async {
    _userActionRecords.add(
      FTUserActionRecord(
        description: 'Keyboard action: Done',
      ),
    );
    return _widgetTester.testTextInput.receiveAction(TextInputAction.done);
  }

  Future<void> timedDrag(
    ft.Finder finder,
    Offset offset,
    Duration duration, {
    int? pointer,
    int buttons = kPrimaryButton,
    double frequency = 60.0,
    bool warnIfMissed = true,
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description:
            '''Timed drag: ${finder.describeMatch(ft.Plurality.one)} by (x: ${offset.dx}, y: ${offset.dy})''',
      ),
    );
    await _widgetTester.timedDrag(
      finder,
      offset,
      duration,
      pointer: pointer,
      buttons: buttons,
      frequency: frequency,
      warnIfMissed: warnIfMissed,
    );
  }

  Future<void> timedDragFrom(
    Offset startLocation,
    Offset offset,
    Duration duration, {
    int? pointer,
    int buttons = kPrimaryButton,
    double frequency = 60.0,
  }) async {
    _userActionRecords.add(
      FTUserActionRecord(
        description:
            '''Timed drag from: (x: ${startLocation.dx}, y: ${startLocation.dy}) by (x: ${offset.dx}, y: ${offset.dy})''',
      ),
    );
    await _widgetTester.timedDragFrom(
      startLocation,
      offset,
      duration,
      pointer: pointer,
      buttons: buttons,
      frequency: frequency,
    );
  }
}
