flutter_get:
	fvm flutter pub get -C packages/amplitude_repository
	fvm flutter pub get -C packages/device_info_provider
	fvm flutter pub get -C packages/flow_test
	fvm flutter pub get -C packages/pieces_painter
	fvm flutter pub get -C packages/sentry_repository
	fvm flutter pub get -C packages/supabase_client_provider
	fvm flutter pub get -C template

flutter_clean:
	cd packages/amplitude_repository && \
	fvm flutter clean && \
	cd ../device_info_provider && \
	fvm flutter clean && \
	cd ../flow_test && \
	fvm flutter clean && \
	cd ../pieces_painter && \
	fvm flutter clean && \
	cd ../sentry_repository && \
	fvm flutter clean && \
	cd ../supabase_client_provider && \
	fvm flutter clean && \
	cd ../../template && \
	fvm flutter clean