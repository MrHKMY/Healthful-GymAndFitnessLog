import 'package:flutter/cupertino.dart';
import 'dart:math';

class CustomTimerPainter extends CustomPainter {
  
  CustomTimerPainter({this.animation, this.backgroundColor, this.color,}) : super(repaint: animation);
   
  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
        ..color = backgroundColor
        ..strokeWidth = 10.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width/2, paint);


    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);

  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}