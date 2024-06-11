import 'dart:convert';

import 'package:final_project_app/models/location.dart';

class LocationsDB{
  final List<Location> _locations;

  List<Location> get all{
    return List<Location>.from(_locations, growable: false);
  }

  // Orders the locations by nearest to furthest from our position
  // Params:
  //  - max: int set to 999
  //  - latitude: required double
  //  - longitude: required double
  // Returns: A list of locations ordered nearest to furthest from our position
  List<Location> nearestTo({int max = 999, required double latitude, required double longitude}) {
    // Sorts the list based off of distance compared between a and b
    _locations.sort((a, b) => a.distanceFrom(latitude: latitude, longitude: longitude).compareTo(b.distanceFrom(latitude: latitude, longitude: longitude)));
    return _locations.take(max).toList();
  }

  LocationsDB.initializeFromJson(String jsonString) : _locations = _decodeVenueListJson(jsonString);

  static List<Location> _decodeVenueListJson(String jsonString){
    final listMap = jsonDecode(jsonString);
    final theList = (listMap as List).map( (element) {
      return Location.fromJson(element);
    }).toList();
    return theList;
  }

}