import 'package:flutter/material.dart';

class InlineBadgePainter extends CustomPainter {
  final int current;
  final int previous;
  final int maxY;

  InlineBadgePainter({
    required this.current,
    required this.previous,
    required this.maxY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final y1 = size.height * (1 - previous / maxY) - 4;
    final y2 = size.height * (1 - current / maxY) - 4;

    final paint = Paint()..strokeWidth = 2;

    final textPainter = TextPainter(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
    );

    void drawLineAndLabel(double y, int value, Color color) {
      textPainter.text = TextSpan(
        text: value.toString(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      );
      textPainter.layout();

      const labelPadding = 8.0;
      final textStartX = labelPadding + 12;
      final textEndX = textStartX + textPainter.width;
      final lineStartX = textEndX + 8;

      final labelOffset = Offset(textStartX, y - textPainter.height / 2);
      textPainter.paint(canvas, labelOffset);

      canvas.drawLine(
        Offset(lineStartX, y),
        Offset(size.width - 16, y),
        paint..color = color,
      );
    }

    drawLineAndLabel(y1, previous, Colors.grey.shade600);
    drawLineAndLabel(y2, current, Colors.green.shade700);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
