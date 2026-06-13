class Mixpanel_EffectProvider_Configuration {
  const Mixpanel_EffectProvider_Configuration({
    required this.sendEvents,
    required this.token,
    required this.environment,
  }) : assert(
         !sendEvents || (sendEvents && token != null && environment != null),
         '''If sendEvents is true, token and environment must be provided''',
       );

  /// Whether or not this effect actually send events via Mixpanel API
  final bool sendEvents;

  /// The token for Mixpanel
  final String? token;

  /// The application's environment
  final String? environment;
}
