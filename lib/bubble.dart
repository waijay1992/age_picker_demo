import 'dart:math';
import 'package:flutter/material.dart';


class BubbleWidget extends StatelessWidget {
  // 尖角高度
  var arrHeight;
  // 圆角半径
  var radius;
  // 宽度
  final width;
  // 高度
  final height;
  // 颜色
  Color color;
  // 边框宽度
  final strokeWidth;
  // 子 Widget
  final child;

  BubbleWidget(
      this.width,
      this.height,
      this.color, {
        Key key,
        this.arrHeight = 12.0,
        this.radius = 20,
        this.strokeWidth = 4.0,
        this.child,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget bubbleWidget = Container(
        width: width,
        height: height,
        child: Stack(children: <Widget>[
          CustomPaint(
              painter: BubbleCanvas(context, width, height, color,
                  arrHeight, radius, strokeWidth)),
        ]));

    return bubbleWidget;
  }
}

class BubbleCanvas extends CustomPainter {
  BuildContext context;
  final arrHeight;
  final radius;
  final width;
  final height;
  final color;
  final strokeWidth;

  BubbleCanvas(
      this.context,
      this.width,
      this.height,
      this.color,
      this.arrHeight,
      this.radius,
      this.strokeWidth,
      );

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = this.strokeWidth;
    paint.strokeCap = StrokeCap.round;
    paint.color = this.color;
    Path bubblePath = new Path();
    bubblePath.arcTo(Rect.fromCircle(
        center: Offset(width / 2, height / 2), radius: height/2-20),
        -265 * (pi / 180),
        350 * (pi / 180),
        false);
    bubblePath.lineTo(width / 2, height-arrHeight);
    bubblePath.close();
    canvas.drawPath(bubblePath, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
