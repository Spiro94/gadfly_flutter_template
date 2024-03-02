// coverage:ignore-file
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

class Uint8ListConverter implements JsonConverter<Uint8List?, List<dynamic>?> {
  const Uint8ListConverter();

  @override
  Uint8List? fromJson(List<dynamic>? json) {
    if (json == null) return null;

    final bytes = <int>[];
    for (final b in json) {
      if (b is int) {
        bytes.add(b);
      }
    }

    return Uint8List.fromList(bytes);
  }

  @override
  List<int>? toJson(Uint8List? object) {
    if (object == null) return null;

    return object.toList();
  }
}
