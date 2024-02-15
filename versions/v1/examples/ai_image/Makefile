flutter_get:
	fvm flutter pub get -C packages/amplitude_repository
	fvm flutter pub get -C packages/device_info_provider
	fvm flutter pub get -C packages/flow_test
	fvm flutter pub get -C packages/gadfly_lints
	fvm flutter pub get -C packages/pieces_painter
	fvm flutter pub get -C packages/sentry_repository
	fvm flutter pub get -C packages/supabase_client_provider
	fvm flutter pub get -C app

flutter_clean:
	cd packages/amplitude_repository && \
	fvm flutter clean && \
	cd ../device_info_provider && \
	fvm flutter clean && \
	cd ../flow_test && \
	fvm flutter clean && \
	cd ../gadfly_lints && \
	fvm flutter clean && \
	cd ../pieces_painter && \
	fvm flutter clean && \
	cd ../sentry_repository && \
	fvm flutter clean && \
	cd ../supabase_client_provider && \
	fvm flutter clean && \
	cd ../../app && \
	fvm flutter clean

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