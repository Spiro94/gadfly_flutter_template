import 'package:flutter/material.dart';

class CreatePieceTool<T> {
  CreatePieceTool({
    required this.canvas,
    required this.size,
    required this.data,
  });

  final Canvas canvas;
  final Size size;
  final T data;
}

class DebugPiece {
  DebugPiece({
    this.debug = false,
    this.brush,
    this.label,
    this.hide = false,
  });

  final bool debug;
  final String? label;
  final Paint? brush;
  final bool hide;
}

sealed class PieceToPaint<T> {}

class ContainerPieceToPaint<T> extends PieceToPaint<T> {
  ContainerPieceToPaint({
    required this.children,
    this.debug,
    this.createPiece,
    this.setSize,
  });

  final void Function(CreatePieceTool<T> tool)? createPiece;
  final Size Function(Size size)? setSize;

  final DebugPiece? debug;

  final List<PieceToPaint<T>>? children;
}

class LeafPieceToPaint<T> extends PieceToPaint<T> {
  LeafPieceToPaint({
    required this.createPiece,
    this.hide = false,
  });

  final bool hide;

  final void Function(CreatePieceTool<T> tool) createPiece;
}
