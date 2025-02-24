import 'dart:convert';

import 'package:colored_json/colored_json.dart' as cv;
import 'package:flutter/material.dart';
import 'package:json_diff/json_diff.dart' as jd;

List<Widget> diffNodeToFlutter(jd.DiffNode diff) => [
      for (final e in diff.removed.entries) ...[
        Text(
          '- Removed at path "${[...diff.path, e.key]}":',
          style: const TextStyle(color: Colors.red),
        ),
        _removedRawJson(
          jsonEncode(
            e.value is Map || e.value is List
                ? e.value
                : {'removed value': e.value},
          ),
        ),
      ],
      for (final e in diff.added.entries) ...[
        Text(
          '+ Added at path "${[...diff.path, e.key]}":',
          style: const TextStyle(color: Colors.teal),
        ),
        _addedRawJson(
          jsonEncode(
            e.value is Map || e.value is List
                ? e.value
                : {'added value': e.value},
          ),
        ),
      ],
      for (final e in diff.changed.entries) ...[
        Text('@ Changed at path "${[...diff.path, e.key]}":'),
        _removedRawJson(
          jsonEncode(
            e.value.first is Map || e.value.first is List
                ? e.value.first
                : {'previous': e.value.first},
          ),
        ),
        _addedRawJson(
          jsonEncode(
            e.value.last is Map || e.value.last is List
                ? e.value.last
                : {'current': e.value.last},
          ),
        ),
      ],
      for (final e in diff.moved.entries) ...[
        Text('@ Moved at path "${[...diff.path, e.key]}"'),
        Text(
          '${e.key} -> ${e.value}',
          style: const TextStyle(color: Colors.orange),
        ),
      ],
      for (final e in diff.node.entries) ...diffNodeToFlutter(e.value),
    ];

Widget rawJson(String data) => cv.ColoredJson(
      data: data,
      colonColor: Colors.grey.shade400,
      commaColor: Colors.grey.shade400,
      keyColor: Colors.grey.shade400,
      curlyBracketColor: Colors.grey.shade400,
      squareBracketColor: Colors.grey.shade400,
    );

Widget _removedRawJson(String data) => cv.ColoredJson(
      data: data,
      colonColor: Colors.grey.shade400,
      commaColor: Colors.grey.shade400,
      keyColor: Colors.grey.shade400,
      intColor: Colors.red,
      boolColor: Colors.red,
      nullColor: Colors.red,
      doubleColor: Colors.red,
      stringColor: Colors.red,
      curlyBracketColor: Colors.grey.shade400,
      squareBracketColor: Colors.grey.shade400,
    );

Widget _addedRawJson(String data) => cv.ColoredJson(
      data: data,
      colonColor: Colors.grey.shade400,
      commaColor: Colors.grey.shade400,
      keyColor: Colors.grey.shade400,
      intColor: Colors.teal,
      boolColor: Colors.teal,
      nullColor: Colors.teal,
      doubleColor: Colors.teal,
      stringColor: Colors.teal,
      curlyBracketColor: Colors.grey.shade400,
      squareBracketColor: Colors.grey.shade400,
    );
