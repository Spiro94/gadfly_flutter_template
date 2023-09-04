import 'dart:async';

import 'package:flow_test/flow_test.dart';
import 'package:flutter/material.dart';

/// {@template ftMockedApp}
/// The [FTMockedApp] is a simple class that takes an [appBuilder] to ensure
/// that all of your tests are created with the same entry point into your
/// application.
/// {@endtemplate}
class FTMockedApp<M> {
  /// {@macro ftMockedApp}
  FTMockedApp({
    required this.appBuilder,
    required this.mocks,
    required this.events,
  });

  /// [appBuilder] should return the root widget of your application. In
  /// otherwords, it should be the widget that you would pass to `runApp`.
  final FutureOr<Widget> Function() appBuilder;

  /// A container for the app's mocks
  final M mocks;

  /// A list of recently added events
  final List<Object> events;

  /// [extras] is a place to store information that you may want to use between
  /// your actions and expectations.
  final Map<String, Object> extras = {};

  // -- Recording for Gallery --

  /// The number of screenshots that have been taken
  int screenshotCounter = 0;

  /// A String representation of the screenshot counter
  String get resolvedCounter => screenshotCounter.toRadixString(36);

  /// What has been recorded througout the test
  final List<FTRecord> records = [];
}
