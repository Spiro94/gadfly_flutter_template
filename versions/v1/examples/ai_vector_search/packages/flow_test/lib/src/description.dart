// ignore_for_file: public_member_api_docs

class FTDescription {
  FTDescription({
    required this.shortDescription,
    this.atScreenshotsLevel = false,
    this.description,
    this.descriptionType,
  });

  final String shortDescription;
  final bool atScreenshotsLevel;
  final String? description;
  final String? descriptionType;
}
