class FTDescription {
  FTDescription({
    required this.directoryName,
    this.atScreenshotsLevel = false,
    this.description,
    this.descriptionType,
  });

  final String directoryName;
  final bool atScreenshotsLevel;
  final String? description;
  final String? descriptionType;
}
