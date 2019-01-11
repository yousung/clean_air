import 'package:flutter/material.dart';
import 'package:air/model/Dust.dart';

class Weather extends InheritedWidget {
  final Dust dust;
  final int level;

  Weather({Key key, this.dust, this.level, @required Widget child})
      : super(key: key, child: child);

  static Weather of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(Weather);
  }

  @override
  bool updateShouldNotify(Weather oldWidget) => dust != oldWidget.dust;
}
