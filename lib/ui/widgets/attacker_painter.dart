import 'package:flutter/material.dart';

import '../../utils/constants/app_constants.dart';

class AttackerPainter extends CustomPainter {
  AttackerPainter({this.color, required this.rightDirection});

  final Color? color;
  final bool rightDirection;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = color ?? AppConstants.attackerDefaultBackgroundColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path0 = Path();
    if (rightDirection) {
      path0.lineTo(0, 0);
      path0.lineTo(size.width * 0.85, 0);
      path0.lineTo(size.width * 1.0, size.height * 0.5);
      path0.lineTo(size.width * 0.85, size.height);
      path0.lineTo(0, size.height);
    } else {
      path0.moveTo(0, size.height * 0.5);
      path0.lineTo(size.width * 0.15, 0);
      path0.lineTo(size.width * 1, 0);
      path0.lineTo(size.width * 1, size.height);
      path0.lineTo(size.width * 0.15, size.height);
      path0.lineTo(0, size.height * 0.5);
    }
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
