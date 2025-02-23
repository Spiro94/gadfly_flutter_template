#!/bin/sh

set -e

# Ensure there is a temp directory
rm -rf temp
mkdir -p temp
cd temp

# Create a new flutter project
fvm flutter create $1 --org $2


# Ensure there is a directory with the app's name under projects/
cd ..
mkdir -p projects/$1/

# Clean up any cruft that may be left behind in the template
cd template/app
fvm flutter clean
rm -rf coverage
rm -rf .idea
fvm flutter pub get
cd ../..

# Copy the template to the temp directory
cp -R template temp

# Remove the directories from the template directory that we do not want to copy over
rm -rf temp/template/app/android
rm -rf temp/template/app/ios
mv temp/template/app/web temp/
rm -f temp/template/.env
rm -rf temp/template/supabase

# Copy the files from the temporary template over to the application's project directory
cp -R temp/template/. projects/$1/
rm -rf projects/$1/packages/

# Copy over the directories we want from the flutter create command over to the project directory
[ -d "temp/$1/android" ] && cp -R temp/$1/android projects/$1/app
[ -d "temp/$1/ios" ] && cp -R temp/$1/ios projects/$1/app
[ -d "temp/$1/web" ] && cp -R temp/$1/web projects/$1/app

rm -f projects/$1/app/web/index.html
cp temp/web/index.html projects/$1/app/web/
cp temp/web/flutter_bootstrap.js projects/$1/app/web/

find projects/$1 -name '*.dart' -exec sed -i '' -e "s/gadfly_flutter_template/$1/g" {} \;
find projects/$1 -name '*.yaml' -exec sed -i '' -e "s/gadfly_flutter_template/$1/g" {} \;
find projects/$1 -name '*.md' -exec sed -i '' -e "s/gadfly_flutter_template/$1/g" {} \;
find projects/$1 -name '*.html' -exec sed -i '' -e "s/gadfly_flutter_template/$1/g" {} \;


# Now that we have changed the app names, we can safely copy in the packages directory
cp -R temp/template/packages projects/$1/

cp -R temp/template/supabase/migrations projects/$1/supabase/
cp -R temp/template/supabase/functions projects/$1/supabase/
cp temp/template/supabase/seed.sql projects/$1/supabase/

cd projects/$1/app

fvm flutter clean
fvm flutter pub get
fvm dart fix --apply


cd ..

supabase init --with-vscode-settings

cd ../..

rm -rf temp
