import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:air/resorce/Permission.dart';

import 'package:air/screen/Air.dart';
import 'package:air/screen/Setting.dart';

class Ready extends StatefulWidget {
  _ReadyState createState() => _ReadyState();
}

class _ReadyState extends State<Ready> {
// Api _api;
  PermissionResource _permissionResource;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    _permissionResource = new PermissionResource();
    await initCheckPermission();

    final SharedPreferences prefs = await _prefs;
    final station = prefs.getString('station');
    station != null ? pageJump(Air()) : pageJump(Setting());
  }

  Future<void> initCheckPermission() async {
    await _permissionResource.permissionCheck();
  }

  void pageJump(Widget _widget) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widget),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [
                0.1,
                0.5,
                0.7,
                0.9
              ],
                  colors: [
                Colors.indigo[800],
                Colors.indigo[700],
                Colors.indigo[600],
                Colors.indigo[400],
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
                    CircleAvatar(
                      backgroundColor: Colors.lightBlue,
                      radius: 50.0,
                      child: Icon(
                        FontAwesomeIcons.wind,
                        color: Colors.black,
                        size: 50.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                    Text(
                      '바람소리',
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                  ),
                  Text('잠시만요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  Text('데이터를 가져오고 있어요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    ));
  }
}
