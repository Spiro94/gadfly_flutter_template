get:
	fvm flutter pub get -C packages/amplitude_repository
	fvm flutter pub get -C packages/app_theme
	fvm flutter pub get -C packages/device_info_provider
	fvm flutter pub get -C packages/gadfly_lints
	fvm flutter pub get -C packages/sentry_repository
	fvm flutter pub get

clean:
	fvm flutter clean packages/amplitude_repository
	fvm flutter clean packages/app_theme
	fvm flutter clean packages/device_info_provider
	fvm flutter clean packages/gadfly_lints
	fvm flutter clean packages/sentry_repository	
	fvm flutter clean

redux_devtools_server:
	remotedev --port 8001

runner_build:
	fvm flutter pub run build_runner build --delete-conflicting-outputs

runner_watch:
	fvm flutter pub run build_runner watch --delete-conflicting-outputs

slang_build:
	fvm flutter pub run slang

slang_watch:
	fvm flutter pub run slang watch

coverage_check:
	rm -rf coverage
	fvm flutter test --no-pub --test-randomize-ordering-seed random --coverage
	lcov --remove coverage/lcov.info -o coverage/filtered.info \
		'**/*.g.dart' \
		'**/*.gr.dart' \
		'**/redux_remote_devtools.dart'
	genhtml coverage/filtered.info --quiet -o coverage
	open coverage/index.html

screenshots_delete:
	find . -type d -name "failures" -exec rm -rf {} +
	find . -type d -name "goldens" -exec rm -rf {} +

screenshots_update:
	find . -type d -name "failures" -exec rm -rf {} +
	find . -type d -name "goldens" -exec rm -rf {} +
	fvm flutter test --update-goldens --dart-define createScreenshots=true