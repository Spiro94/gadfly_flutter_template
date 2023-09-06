flutter_get:
	fvm flutter pub get -C packages/amplitude_repository
	fvm flutter pub get -C packages/app_theme
	fvm flutter pub get -C packages/device_info_provider
	fvm flutter pub get -C packages/flow_test
	fvm flutter pub get -C packages/gadfly_lints
	fvm flutter pub get -C packages/pieces_painter
	fvm flutter pub get -C packages/sentry_repository
	fvm flutter pub get -C app

flutter_clean:
	fvm flutter clean packages/amplitude_repository
	fvm flutter clean packages/app_theme
	fvm flutter clean packages/device_info_provider
	fvm flutter clean packages/flow_test
	fvm flutter clean packages/gadfly_lints
	fvm flutter clean packages/pieces_painter
	fvm flutter clean packages/sentry_repository	
	fvm flutter clean app

redux_devtools_server:
	remotedev --port 8001

runner_build:
	cd app && \
	fvm flutter pub run build_runner build --delete-conflicting-outputs

runner_watch:
	cd app && \
	fvm flutter pub run build_runner watch --delete-conflicting-outputs

slang_build:
	cd app && \
	fvm flutter pub run slang

slang_watch:
	cd app && \
	fvm flutter pub run slang watch

coverage_check:
	cd app && \
	rm -rf coverage && \
	fvm flutter test --no-pub --test-randomize-ordering-seed random --coverage --dart-define silenceLogs=true && \
	lcov --remove coverage/lcov.info -o coverage/filtered.info \
		'**/*.g.dart' \
		'**/*.gr.dart' \
		'**/redux_remote_devtools.dart' && \
	genhtml coverage/filtered.info --quiet -o coverage && \
	open coverage/index.html

screenshots_delete:
	cd app && \
	rm -rf test/gallery && \
	find . -type d -name "failures" -exec rm -rf {} + && \
	find . -type d -name "screenshots" -exec rm -rf {} +

screenshots_update:
	cd app && \
	rm -rf test/gallery && \
	find . -type d -name "failures" -exec rm -rf {} + && \
	find . -type d -name "screenshots" -exec rm -rf {} + && \
	fvm flutter test --update-goldens --dart-define createScreenshots=true --dart-define silenceLogs=true

gallery:
	cd app && \
	mkdocs serve
