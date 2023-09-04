!/bin/bash

set -e

mkdir -p temp
cd temp

# This should be your full flutter create command
$*

cd ..
mkdir -p projects/$3/app

cp -R template/. projects/$3/app
cp -R packages projects/$3

[ -d "temp/$3/android" ] && cp -R temp/$3/android projects/$3/app
[ -d "temp/$3/ios" ] && cp -R temp/$3/ios projects/$3/app
[ -d "temp/$3/web" ] && cp -R temp/$3/web projects/$3/app

find projects/$3/app -name '*.dart' -exec sed -i '' -e "s/gadfly_flutter_template/$3/g" {} \;
find projects/$3/app -name '*.yaml' -exec sed -i '' -e "s/gadfly_flutter_template/$3/g" {} \;
find projects/$3/app -name '*.md' -exec sed -i '' -e "s/gadfly_flutter_template/$3/g" {} \;

cd projects/$3/app

flutter clean
flutter pub get
dart fix --apply

mv .fvm ../
mv .vscode ../
mv Makefile ../
mv README.md ../

cd ../../..

rm -rf temp
