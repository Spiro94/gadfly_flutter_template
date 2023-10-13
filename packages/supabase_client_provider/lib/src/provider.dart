import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_client_provider/src/configuration.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientProvider {
  SupabaseClientProvider({
    required this.config,
  });

  final SupabaseClientProviderConfiguration config;
  final _appLinks = AppLinks();

  SupabaseClient get client => Supabase.instance.client;

  Stream<Uri>? deepLinksStream;

  Future<void> init() async {
    await Supabase.initialize(
      url: config.url,
      anonKey: config.anonKey,
      // We are preenting supabase from handling deep links, so we can handle
      // them ourseles.
      ignoreDeepLinks: true,
    );

    if (!kIsWeb) {
      // This will handle app links while the app is already started - be it in
      // the foreground or in the background.
      //
      // Note: supabase_flutter is also using [AppLinks], but we want to usurp
      // control of app links from supabase_flutter. It is a design flaw of
      // theirs to control deep links entirely. To take control, we are taking
      // advantage of an implementation detail of AppLinks where only the latest
      // listener will receive events. Since this list was created later, it
      // will win and receive events.
      deepLinksStream = _appLinks.uriLinkStream.map((uriRaw) {
        // To be able to use Supabase's tooling to check for a session in the
        // URI, we need to rebuild the URI be pretending the first fragment
        // (that has our deep link path) wasn't a fragment.
        final uriSplit = uriRaw.toString().split('#');
        final uri = uriSplit.last;

        // We will check if there was a second fragment with an access token,
        // and if so, we will add the '#' back.
        if (uri.contains('%23') && uri.contains('access_token')) {
          return Uri.parse(uri.replaceFirst('%23', '#'));
        }

        return Uri.parse(uri);
      });
    }
  }
}
