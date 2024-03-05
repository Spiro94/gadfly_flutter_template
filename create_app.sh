!/bin/bash

set -e

mkdir -p temp
cd temp

# This should be your full flutter create command
$*

cd ..
mkdir -p projects/$4/app

cp -R template/. projects/$4/app
cp -R packages projects/$4

[ -d "temp/$4/android" ] && cp -R temp/$4/android projects/$4/app
[ -d "temp/$4/ios" ] && cp -R temp/$4/ios projects/$4/app
[ -d "temp/$4/web" ] && cp -R temp/$4/web projects/$4/app

find projects/$4/app -name '*.dart' -exec sed -i '' -e "s/gadfly_flutter_template/$4/g" {} \;
find projects/$4/app -name '*.yaml' -exec sed -i '' -e "s/gadfly_flutter_template/$4/g" {} \;
find projects/$4/app -name '*.md' -exec sed -i '' -e "s/gadfly_flutter_template/$4/g" {} \;

cd projects/$4/app

fvm flutter clean
fvm flutter pub get
fvm dart fix --apply

mv .fvm ../
mv docs ../
mv .github ../
mv .vscode ../
mv Makefile ../
mv README.md ../
mv .gitignore_top_level ../.gitignore
mkdir -p ../supabase/functions
mv import_map.json ../supabase/functions

cd ..

supabase init 

cd ../..

rm -rf temp
