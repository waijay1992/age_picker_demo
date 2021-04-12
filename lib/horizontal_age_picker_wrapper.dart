import 'package:flutter/material.dart';
import 'horizontal_age_picker.dart';
import 'bubble.dart';

class HorizontalAgePickerWrapper extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final int step;

  ///控件的宽度
  final int widgetWidth;

  ///一大格中有多少个小格
  final int subGridCountPerGrid;

  ///每一小格的宽度
  final int subGridWidth;

  final void Function(int) onSelectedChanged;

  ///标题文字颜色
  final Color titleTextColor;

  ///刻度颜色
  final Color scaleColor;

  ///指示器颜色
  final Color indicatorColor;

  ///刻度文字颜色
  final Color scaleTextColor;

  HorizontalAgePickerWrapper({
    Key key,
    this.initialValue = 20,
    this.minValue = 0,
    this.maxValue = 120,
    this.step = 1,
    this.widgetWidth = 200,
    // 10岁一个大格
    this.subGridCountPerGrid = 10,
    this.subGridWidth = 8,
    @required this.onSelectedChanged,
    this.titleTextColor = Colors.black,
    this.scaleColor = Colors.blueGrey,
    this.indicatorColor = Colors.blue,
    this.scaleTextColor = Colors.black,
  }) : super(key: key) {}

  @override
  State<StatefulWidget> createState() {
    return HorizontalAgePickerWrapperState();
  }
}

class HorizontalAgePickerWrapperState
    extends State<HorizontalAgePickerWrapper> {
  int _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  void didUpdateWidget(HorizontalAgePickerWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    int numberPickerHeight = 60;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            BubbleWidget(160, 160, const Color(0xFFb7d0e8)),
            Text(
              _selectedValue.toString(),
              style: TextStyle(
                color: widget.titleTextColor,
                fontSize: 40,
              ),
            ),
          ],
        ),
        Container(width: 0, height: 10),
        HorizontalAgePicker(
          initialValue: widget.initialValue,
          minValue: widget.minValue,
          maxValue: widget.maxValue,
          step: widget.step,
          widgetWidth: widget.widgetWidth,
          widgetHeight: numberPickerHeight,
          subGridCountPerGrid: widget.subGridCountPerGrid,
          subGridWidth: widget.subGridWidth,
          onSelectedChanged: (value) {
            widget.onSelectedChanged(value);
            setState(() {
              _selectedValue = value;
            });
          },
          scaleColor: widget.scaleColor,
          indicatorColor: widget.indicatorColor,
          scaleTextColor: widget.scaleTextColor,
        ),
      ],
    );
  }
}
