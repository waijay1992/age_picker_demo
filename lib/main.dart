import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'horizontal_age_picker_wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NumberFormat _numberFormat = NumberFormat(',000');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: new Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        // 中间的进度条
        title: LinearProgressIndicator(
          value: 0.125,
          backgroundColor: Colors.grey, // 背景色为黑色
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // 进度条颜色为
        ),
        // 进度现实
        actions: [
          new Container(
            child: new Text(
              "1/8",
              textAlign: TextAlign.center,
              style: new TextStyle(color: Colors.black, fontSize: 24),
            ),
            color: Colors.white,
            margin: const EdgeInsets.all(5.0),
          ),
        ],
      ),

      body: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 40),
        child: Stack(
          children: <Widget>[
            Container(height: 10),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                  padding: new EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                  child: Container(
                    child: new Text(
                      'How old are you?',
                      style: new TextStyle(
                          color: Colors.black, backgroundColor: Colors.white,
                          fontSize:28, fontWeight:FontWeight.bold),
                    ),
                  )),
            ),
            Align(
              alignment: Alignment.center,
              child: HorizontalAgePickerWrapper(
                initialValue: 34,
                minValue: -2,
                maxValue: 118,
                step: 1,
                widgetWidth: MediaQuery.of(context).size.width.round() - 30,
                subGridCountPerGrid: 10,
                subGridWidth: 60,
                onSelectedChanged: (value) {
                  print(value);
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                  padding: new EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                  child: Container(
                    child: new RaisedButton(
                      // borderSide:new BorderSide(color: Colors.green),
                      child: new Text(
                        'Continue',
                        style: new TextStyle(
                            color: Colors.white, backgroundColor: Colors.blue),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      color: Colors.blue,
                      onPressed: () {},
                    ),
                  )),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
