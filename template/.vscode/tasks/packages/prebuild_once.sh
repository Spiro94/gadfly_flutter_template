#!/bin/sh

cd bloc_devtools_extension 
fvm flutter clean 
fvm dart pub get
fvm flutter pub run build_runner build --delete-conflicting-outputs

cd ../

cd flow_test 
fvm flutter clean 
fvm dart pub get
