#!/bin/sh

rm -rf coverage
fvm flutter test --no-pub --test-randomize-ordering-seed random --coverage --dart-define createScreenshots=true --dart-define silenceLogs=true
lcov --remove coverage/lcov.info -o coverage/filtered.info \
  '**/*.g.dart' \
  '**/outside/**/*.dart' \
  '**/configurations/**/*.dart'
genhtml coverage/filtered.info --quiet -o coverage
open coverage/index.html