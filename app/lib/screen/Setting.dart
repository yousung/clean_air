import 'package:flutter/material.dart';
import 'package:air/resorce/Api.dart';
import 'package:air/model/Station.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Air.dart';

class Setting extends StatefulWidget {
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Api api = Api();
  List<Station> _station = [];
  Widget _nowWidget;

  void initState() {
    super.initState();
    _nowWidget = readyScreen();
  }

  _onChoice(int idx) async {
    final name = _station[idx].stationName;
    final SharedPreferences prefs = await _prefs;
    prefs.setString('station', name);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Air()),
    );
  }

  void _getData() async {
    setState(() {
      _nowWidget = loadingScreen();
    });
    final station = await api.getState();
    setState(() {
      _station = station;
      _nowWidget = listScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('지역 설정'),
      ),
      body: _nowWidget,
      floatingActionButton: _station.length > 0
          ? null
          : FloatingActionButton(
              onPressed: _getData,
              child: Icon(Icons.gps_fixed),
            ),
    );
  }

  Widget listScreen() {
    return ListView.builder(
      itemCount: _station.length,
      itemBuilder: (BuildContext context, int idx) {
        final station = _station[idx];
        return ListTile(
          onTap: () => _onChoice(idx),
          contentPadding: EdgeInsets.all(15),
          title: Text(station.stationName),
          subtitle: Text(station.addr),
          trailing: Text('거리\n${station.tm.toString()}'),
        );
      },
    );
  }

  Widget readyScreen() {
    return Center(
      child: Text(
        '버튼을 클릭하여 불러오기..\n\n하루에 3번까지 초기화 가능합니다..',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  Widget loadingScreen() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
