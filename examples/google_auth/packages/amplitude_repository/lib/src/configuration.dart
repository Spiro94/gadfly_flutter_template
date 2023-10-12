/// {@template amplitudeRepository.configuration}
/// Configuration for `AmplitudeRepository`
/// {@endtemplate}
class AmplitudeRepositoryConfiguration {
  /// {@macro amplitudeRepository.configuration}
  AmplitudeRepositoryConfiguration({
    required this.apiKey,
    required this.sendEvents,
  });

  /// The API key for amplitude
  final String apiKey;

  /// Whether or not to actually send analytic events to amplitude. This is
  /// useful to set to false when developing.
  final bool sendEvents;
}
