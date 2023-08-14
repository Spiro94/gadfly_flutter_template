!/bin/bash

set -e

mkdir -p temp
cd temp

# This should be your full flutter create command
$*

cd ..
mkdir -p projects

cp -R template/. projects/$3

[ -d "temp/$3/android" ] && cp -R temp/$3/android projects/$3
[ -d "temp/$3/ios" ] && cp -R temp/$3/ios projects/$3
[ -d "temp/$3/web" ] && cp -R temp/$3/web projects/$3

find projects/$3 -name '*.dart' -exec sed -i '' -e "s/gadfly_flutter_template/$3/g" {} \;
find projects/$3 -name '*.yaml' -exec sed -i '' -e "s/gadfly_flutter_template/$3/g" {} \;
find projects/$3 -name '*.md' -exec sed -i '' -e "s/gadfly_flutter_template/$3/g" {} \;

cd projects/$3

flutter clean
flutter pub get
dart fix --apply

cd ../..

rm -rf temp
