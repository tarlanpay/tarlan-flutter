import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  Color? customColor;
  DashedLinePainter({this.customColor});
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 3, dashSpace = 2, startX = 0;
    final paint = Paint()
      ..color = customColor ?? Colors.grey
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DashedLine extends StatelessWidget {
  Color? color;
  DashedLine({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: DashedLinePainter(customColor: color));
  }
}
