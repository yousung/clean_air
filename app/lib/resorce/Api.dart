import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:air/model/Station.dart';
import 'package:air/model/Dust.dart';

const BASE_URL = 'http://api.air.ysrim.com/api/';

class Api {
  Position _position;

  Future<List<Station>> getState() async {
    await _getLocation();

    final response = await http
        .get(BASE_URL + 'tm?x=${_position.longitude}&y=${_position.latitude}');

    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

    return parsed.map<Station>((json) => Station.fromJson(json)).toList();
  }

  Future<void> _getLocation() async {
    _position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<Dust> getDust(String station) async {
    final response = await http.get(BASE_URL + 'dust?station=$station');
    final jsonData = json.decode(response.body);
    return Dust.fromJson(jsonData);
  }
}
