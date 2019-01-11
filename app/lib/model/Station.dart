class Station {
  String stationName;
  String addr;
  double tm;

  Station({this.stationName, this.tm, this.addr});

  factory Station.fromJson(Map<String, dynamic> jsonData) {
    return Station(
        stationName: jsonData['stationName'],
        addr: jsonData['addr'],
        tm: jsonData['tm']);
  }
}
