class Dust {
  String station;
  String dataTime;
  int coGrade;
  int pm10Grade;
  int pm25Grade;

  Dust({this.station, this.pm10Grade, this.pm25Grade, this.dataTime});

  factory Dust.fromJson(Map<String, dynamic> jsonData) {
    return Dust(
      station: jsonData['station'],
      pm10Grade: jsonData['pm10Grade'],
      pm25Grade: jsonData['pm25Grade'],
      dataTime: jsonData['dataTime'],
    );
  }
}
