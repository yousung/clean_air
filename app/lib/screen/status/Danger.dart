import 'package:flutter/material.dart';
import 'package:air/helper/font_icon_icons.dart';
import 'Weather.dart';

// 위험
class Danger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Weather inherWidget = Weather.of(context);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Colors.red,
                Colors.redAccent,
              ])),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontIcon.danger,
                      color: Colors.white,
                      size: 150.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                    ),
                    Text(
                      '위험해요',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text('오늘은 정말 최악이에요..\n\n창문도 모두 닫아주세요..',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0)),
            ),
            Text(
                '${inherWidget.dust.station} / ${inherWidget.dust.dataTime.toString()}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16.0)),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            Text(
                '미세먼지 ${inherWidget.dust.pm10Grade} / 초미세먼지 ${inherWidget.dust.pm25Grade}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16.0)),
            Padding(
              padding: EdgeInsets.all(10),
            )
          ],
        )
      ],
    );
  }
}
