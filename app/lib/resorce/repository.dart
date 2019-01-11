import 'package:air/model/Station.dart';

class Repository {
  List<Source> sources = <Source>[
    // sqlLite,
  ];

  Future<List<Station>> fetchItem() {
    return sources[0].fetchItem();
  }
}

abstract class Source {
  Future<List<Station>> fetchItem();
}
