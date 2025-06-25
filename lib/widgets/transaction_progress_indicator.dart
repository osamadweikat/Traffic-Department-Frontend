import 'dart:math';
import 'package:flutter/material.dart';

class TransactionProgressIndicator extends StatefulWidget {
  final int steps;
  final int completedSteps;
  final List<String> stepLabels;
  final List<String> stepStatus;

  const TransactionProgressIndicator({
    super.key,
    required this.steps,
    required this.completedSteps,
    required this.stepLabels,
    required this.stepStatus,
  });

  @override
  State<TransactionProgressIndicator> createState() =>
      _TransactionProgressIndicatorState();
}

class _TransactionProgressIndicatorState
    extends State<TransactionProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ProgressPainter(
            steps: widget.steps,
            completedSteps: widget.completedSteps,
            stepLabels: widget.stepLabels,
            stepStatus: widget.stepStatus,
            animationValue: _controller.value,
            textDirection: direction,
          ),
          size: const Size(350, 350),
        );
      },
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final int steps;
  final int completedSteps;
  final List<String> stepLabels;
  final List<String> stepStatus;
  final double animationValue;
  final TextDirection textDirection;

  _ProgressPainter({
    required this.steps,
    required this.completedSteps,
    required this.stepLabels,
    required this.stepStatus,
    required this.animationValue,
    required this.textDirection,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case "مكتملة":
      case "Completed":
        return Colors.green;
      case "قيد المعالجة":
      case "قيد المراجعة":
      case "Processing":
      case "Reviewing":
        return Colors.orange;
      case "مرفوضة":
      case "Rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 50;
    final angleStep = 2 * pi / steps;

    final Paint dashedPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Paint solidPaint = Paint()
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < steps; i++) {
      final startAngle = angleStep * i - pi / 2;
      final sweepAngle = angleStep;
      final isCompleted = i < completedSteps;

      if (isCompleted) {
        solidPaint.color = _getStatusColor(stepStatus[i]);
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle * animationValue,
          false,
          solidPaint,
        );

        _drawArrowOnArc(
          canvas,
          center,
          radius,
          startAngle,
          sweepAngle,
          animationValue,
          solidPaint.color,
        );
      } else {
        _drawDashedArc(canvas, center, radius, startAngle, sweepAngle, dashedPaint);
      }
    }

    for (int i = 0; i < steps; i++) {
      final angle = angleStep * i - pi / 2;
      final dx = center.dx + radius * cos(angle);
      final dy = center.dy + radius * sin(angle);

      final bool isCompleted = i < completedSteps;
      final Color color = _getStatusColor(stepStatus[i]);

      final Paint circlePaint = Paint()
        ..color = isCompleted ? color : Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dx, dy), 25, Paint()..color = Colors.black.withOpacity(0.1));
      canvas.drawCircle(Offset(dx, dy), 23, circlePaint);
      canvas.drawCircle(
        Offset(dx, dy),
        23,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: stepLabels[i],
          style: TextStyle(
            fontSize: 9,
            color: isCompleted ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: textDirection,
      )..layout(maxWidth: 50);

      textPainter.paint(
        canvas,
        Offset(dx - textPainter.width / 2, dy - textPainter.height / 2),
      );
    }
  }

  void _drawDashedArc(Canvas canvas, Offset center, double radius, double startAngle, double sweepAngle, Paint paint) {
    const int dashCount = 30;
    const double gapFactor = 0.5;
    final double offset = 2 * pi * animationValue;

    for (int i = 0; i < dashCount; i++) {
      final t1 = startAngle + sweepAngle * (i / dashCount) + offset;
      final t2 = t1 + sweepAngle * (gapFactor / dashCount);
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), t1, t2 - t1, false, paint);
    }
  }

  void _drawArrowOnArc(Canvas canvas, Offset center, double radius, double startAngle, double sweepAngle, double animationValue, Color color) {
    final double arrowSize = 14;
    final double arrowAngle = startAngle + sweepAngle * animationValue - pi / 12;
    final arrowTip = Offset(center.dx + radius * cos(arrowAngle), center.dy + radius * sin(arrowAngle));
    final double direction = arrowAngle + pi / 2;

    final path = Path()
      ..moveTo(arrowTip.dx, arrowTip.dy)
      ..lineTo(arrowTip.dx - arrowSize * cos(direction - pi / 6), arrowTip.dy - arrowSize * sin(direction - pi / 6))
      ..moveTo(arrowTip.dx, arrowTip.dy)
      ..lineTo(arrowTip.dx - arrowSize * cos(direction + pi / 6), arrowTip.dy - arrowSize * sin(direction + pi / 6));

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
