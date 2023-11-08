import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'package:pieces_painter/src/piece_to_paint.dart';

enum PiecesPainterDebugMode {
  none,
  showContainerBoxes,
  showContainerBoxesButHideLeaves,
}

class PiecesPainter<T> extends CustomPainter {
  PiecesPainter({
    required this.debugMode,
    required this.defaultDebugBrush,
    required this.pieces,
    required this.data,
  });

  final PiecesPainterDebugMode debugMode;
  final Paint defaultDebugBrush;
  final List<PieceToPaint<T>> pieces;
  final T data;

  bool get shouldDebug => debugMode != PiecesPainterDebugMode.none;

  void _paintPieces({
    required List<PieceToPaint<T>> pieces,
    required Canvas canvas,
    required T data,
    required Size size,
    required Paint debugBrush,
    required bool debugPiece,
    required String? debugLabel,
    required TextStyle? debugLabelStyle,
  }) {
    if (debugPiece) {
      canvas.drawRect(
        Rect.fromPoints(
          Offset.zero,
          Offset(size.width, size.height),
        ),
        debugBrush,
      );

      if (debugLabel != null) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: debugLabel,
            style: debugLabelStyle,
          ),
          textDirection: ui.TextDirection.ltr,
        )..layout(
            maxWidth: size.width,
          );

        textPainter.paint(
          canvas,
          const Offset(4, 4),
        );
      }
    }

    for (final piece in pieces) {
      switch (piece) {
        case ContainerPieceToPaint():
          if (piece.debug != null && piece.debug!.hide) break;
          canvas.save();
          final updatedSize = piece.createPiece?.call(
            CreatePieceTool(canvas: canvas, size: size, data: data),
          );

          if (piece.children != null) {
            _paintPieces(
              pieces: piece.children!,
              canvas: canvas,
              data: data,
              size: updatedSize ?? size,
              debugBrush: piece.debug?.brush ?? defaultDebugBrush,
              debugPiece: piece.debug?.debug ?? shouldDebug,
              debugLabel: piece.debug?.label,
              debugLabelStyle: piece.debug?.labelStyle,
            );
          }
          canvas.restore();

        case LeafPieceToPaint():
          if (debugMode ==
                  PiecesPainterDebugMode.showContainerBoxesButHideLeaves ||
              piece.hide) {
            break;
          }

          piece.createPiece(
            CreatePieceTool(canvas: canvas, size: size, data: data),
          );
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _paintPieces(
      pieces: pieces,
      canvas: canvas,
      size: size,
      data: data,
      debugBrush: defaultDebugBrush,
      debugPiece: shouldDebug,
      debugLabel: null,
      debugLabelStyle: null,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
