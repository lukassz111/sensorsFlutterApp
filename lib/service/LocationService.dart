
import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:wbudy_apka/model/LatLong.dart';

class LocationService {
  static LocationService _instance = null;
  factory LocationService() {
    if(_instance == null) {
      _instance = new LocationService._constructor();
    }
    return _instance;
  }
  LocationService._constructor() {}
  final String _isPositionAvailableMethod = "isPositionAvailable";
  final String _getPositionMethod = "getPosition";
  final String _startGpsMethod = "startGps";
  final MethodChannel _platform = const MethodChannel('samples.flutter.dev/gps');

  Future startGps() async {
    await _platform.invokeMethod(_startGpsMethod);
  }

  Future<HashMap<String,dynamic>> getPosition() async {
    Map result = await _platform.invokeMethod(_getPositionMethod);
    var output = HashMap<String,dynamic>();
    if(result.isEmpty)
      return output;
    result.forEach((key, value) {
      output.putIfAbsent(key.toString(), () => value);
    });
    if(!output.containsKey('isPositionAvailable')) {
      output.clear();
      return output;
    }
    output['isPositionAvailable'] = output['isPositionAvailable'] == 'true' ? true : false;
    if(output['isPositionAvailable']) {
      double lat = double.parse(result['latitude']);
      double long = double.parse(result['longtitude']);
      output.remove('latitude');
      output.remove('longtitude');
      output.putIfAbsent('latlong', () => LatLong(lat,long));
    }
    return output;
  }

  Future<bool> isPositionAvailable() async {
    return await _platform.invokeMethod(_isPositionAvailableMethod);
  }

}