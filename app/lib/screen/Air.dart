import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:air/resorce/Api.dart';

// View Import
import 'package:air/screen/status/Danger.dart';
import 'package:air/screen/status/Good.dart';
import 'package:air/screen/status/Normal.dart';
import 'package:air/screen/status/Waring.dart';
import 'package:air/screen/status/Weather.dart';
import 'package:air/screen/status/Ready.dart';

import 'Setting.dart';

// Model
import 'package:air/model/Dust.dart';

class Air extends StatefulWidget {
  @override
  _AirState createState() => _AirState();
}

class _AirState extends State<Air> {
  Api _api = Api();
  bool isPermission = false;
  int _count = 0;
  int _level = 0;
  String text = '테스트';
  Dust _dust;

  List<Widget> _dustView = [Good(), Normal(), Waring(), Danger()];

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void initState() {
    super.initState();

    initCount();
    getDustData();
  }

  Future<void> initCount() async {
    SharedPreferences prf = await _prefs;
    setState(() {
      _count = prf.getInt(parseTodayDate()) ?? 3;
    });
  }

  String parseTodayDate() {
    final _now = DateTime.now();
    return "${_now.year}${_now.month}${_now.day}";
  }

  Future<void> changeSaveCount(int cnt) async {
    setState(() {
      _count = cnt;
    });
    SharedPreferences prf = await _prefs;
    prf.setInt(parseTodayDate(), _count);
  }

  Future<void> viewAdAndChangeCount() async {
    //TODO 광고
    Future.delayed(const Duration(milliseconds: 5000), () {
      _jumpSetting();
    });
  }

  Future<void> getDustData() async {
    SharedPreferences prf = await _prefs;
    var station = prf.getString('station');
    if (station != null) {
      var dust = await _api.getDust(station);
      setState(() {
        _dust = dust;
        _level = ((dust.pm10Grade + dust.pm25Grade) / 2).floor();
      });
    }
  }

  // 새로고침
  void _refresh() async {
    if (_count <= 0) {
      await viewAdAndChangeCount();
    } else {
      changeSaveCount((_count - 1));
      getDustData();
      _jumpSetting();
    }
  }

  Future<void> _jumpSetting() async {
    SharedPreferences prf = await _prefs;
    prf.remove('station');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Setting()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: dustViewScreen(),
        floatingActionButton: (_level != 0 && _dust != null)
            ? Container(
                width: 50,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: Stack(
                    alignment: Alignment(10, -10),
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 10,
                        child: Text(
                          _count.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Icon(
                        Icons.refresh,
                        color: Colors.black,
                      )
                    ],
                  ),
                  onPressed: _refresh,
                ),
              )
            : null,
      ),
    );
  }

  Widget dustViewScreen() {
    return _dust != null
        ? Weather(
            dust: _dust,
            level: _level,
            child: _dustView[_level - 1],
          )
        : Ready();
  }
}
