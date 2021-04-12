import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class HorizontalAgePicker extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final int step;

  ///控件的宽度
  final int widgetWidth;

  ///控件的高度
  final int widgetHeight;

  ///大格的总数
  int gridCount;
  ///一大格中有多少个小格
  final int subGridCountPerGrid;

  ///大格的宽度
  int gridWidth;
  ///每一小格的宽度
  final int subGridWidth;

  int listViewItemCount;

  double paddingItemWidth;

  final void Function(int) onSelectedChanged;

  ///刻度颜色
  final Color scaleColor;

  ///指示器颜色
  final Color indicatorColor;

  ///刻度文字颜色
  final Color scaleTextColor;

  HorizontalAgePicker({
    Key key,
    this.initialValue = 34,
    this.minValue = 0,
    this.maxValue = 130,
    this.step = 1,
    this.widgetWidth = 200,
    this.widgetHeight = 60,
    this.subGridCountPerGrid = 10,
    this.subGridWidth = 8,
    @required this.onSelectedChanged,
    this.scaleColor = const Color(0xFFE9E9E9),
    this.indicatorColor = const Color(0xFF3995FF),
    this.scaleTextColor = const Color(0xFF8E99A0),
  }) : super(key: key) {

    if ((maxValue - minValue) % step != 0) {
      throw Exception("(maxValue - minValue)必须是step的整数倍");
    }
    int totalSubGridCount = (maxValue - minValue) ~/ step;

    //第一个grid和最后一个grid都只会展示一半数量的subGrid，因此gridCount需要+1
    gridCount = totalSubGridCount ~/ subGridCountPerGrid + 1;

    gridWidth = subGridWidth * subGridCountPerGrid;

    listViewItemCount = gridCount;

    //空白item的宽度
    paddingItemWidth = widgetWidth / 2 - gridWidth / 2;

  }

  @override
  State<StatefulWidget> createState() {
    return HorizontalAgePickerState();
  }
}

class HorizontalAgePickerState extends State<HorizontalAgePicker> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    // 初始定位
    _scrollController = ScrollController(
      // 计算初始偏移量
      initialScrollOffset: ((widget.initialValue - widget.minValue) /
          widget.step -widget.subGridCountPerGrid~/2 )  *
          widget.subGridWidth,
    );
  }

  ///处理state的复用
  void didUpdateWidget(HorizontalAgePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    _scrollController?.dispose();
    // 初始ListView定位
    _scrollController = ScrollController(
      //计算初始偏移量
      initialScrollOffset: ((widget.initialValue - widget.minValue) /
          widget.step  -widget.subGridCountPerGrid~/2)  *
          widget.subGridWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.widgetWidth.toDouble(),
      height: widget.widgetHeight.toDouble(),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          NotificationListener(
            onNotification: _onNotification,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              // 元素个数
              itemCount: widget.listViewItemCount,
              itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: AgePickerItem(
                      subGridCount: widget.subGridCountPerGrid,
                      subGridWidth: widget.subGridWidth,
                      itemHeight: widget.widgetHeight,
                      valueStr: (widget.minValue +
                          (index) *
                              widget.subGridCountPerGrid *
                              widget.step).toString(),
                      scaleColor: widget.scaleColor,
                      scaleTextColor: widget.scaleTextColor,
                    ),
                  );
                }
            ),
          ),
          // 指示器，不动
          Container(
            width: 6,
            height: widget.widgetHeight*7 / 8,
            color: widget.indicatorColor,
          ),
        ],
      ),
    );
  }

  // 回调选中的值
  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      //距离widget中间最近的刻度值
      int centerValue =
          (notification.metrics.pixels / widget.subGridWidth).round() *
              widget.step +
              widget.minValue + widget.subGridCountPerGrid~/2;
      print("otification.metrics.pixels " + notification.metrics.pixels.toString() +" centerValue "+centerValue.toString());
      // 通知回调选中值改变了
      widget.onSelectedChanged(centerValue);

    }
    return true;
  }

  ///选中值
  select(int valueToSelect) {
    _scrollController.animateTo(
      (valueToSelect - widget.minValue) / widget.step * widget.subGridWidth,
      duration: Duration(milliseconds: 200),
      curve: Curves.decelerate,
    );
  }
}

class AgePickerItem extends StatelessWidget {
  // 小格数目
  final int subGridCount;
  final int subGridWidth;
  final int itemHeight;
  final String valueStr;

  final Color scaleColor;
  final Color scaleTextColor;

  const AgePickerItem({
    Key key,
    @required this.subGridCount,
    @required this.subGridWidth,
    @required this.itemHeight,
    @required this.valueStr,
    @required this.scaleColor,
    @required this.scaleTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double itemWidth = (subGridWidth * subGridCount).toDouble();
    double itemHeight = this.itemHeight.toDouble();

    return CustomPaint(
      size: Size(itemWidth, itemHeight),
      painter: AgeItemPainter(this.subGridWidth, this.valueStr,
          this.scaleColor, this.scaleTextColor),
    );
  }
}

class AgeItemPainter extends CustomPainter {
  final int subGridWidth;

  final String valueStr;

  final Color scaleColor;

  final Color scaleTextColor;

  Paint _linePaint;

  AgeItemPainter(this.subGridWidth, this.valueStr,
      this.scaleColor, this.scaleTextColor) {
    _linePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = scaleColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawLine(canvas, size);
    drawText(canvas, size);
  }

  void drawLine(Canvas canvas, Size size) {
    double startX = 0, endX = size.width;
    canvas.drawLine(Offset(startX, size.height/2),
        Offset(endX, size.height/2), _linePaint);
    // 中间往两边扩
    for (double x = startX; x <= endX; x += subGridWidth) {
      if (x == size.width / 2) {
        canvas.drawLine(
            Offset(x, 0), Offset(x, size.height * 3 / 8), _linePaint);
      } else {
        // 短刻度
        canvas.drawLine(Offset(x, 0), Offset(x, size.height / 4), _linePaint);
      }
    }
  }

  void drawText(Canvas canvas, Size size) {
    //文字水平方向居中对齐，竖直方向底对齐
    ui.Paragraph p = _buildText(valueStr, size.width);
    //获得文字的宽高
    double halfWidth = p.minIntrinsicWidth / 2;
    double halfHeight = p.height / 2;
    canvas.drawParagraph(
        p, Offset(size.width / 2 - halfWidth, size.height - p.height));
  }

  ui.Paragraph _buildText(String content, double maxWidth) {
    ui.ParagraphBuilder paragraphBuilder =
    ui.ParagraphBuilder(ui.ParagraphStyle());
    paragraphBuilder.pushStyle(
      ui.TextStyle(
        fontSize: 14,
        color: this.scaleTextColor,
      ),
    );
    paragraphBuilder.addText(content);

    ui.Paragraph paragraph = paragraphBuilder.build();
    paragraph.layout(ui.ParagraphConstraints(width: maxWidth));

    return paragraph;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
