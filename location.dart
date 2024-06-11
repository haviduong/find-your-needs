import 'package:json_annotation/json_annotation.dart';
import 'dart:math';

/// This allows the `location` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'location.g.dart';

@JsonSerializable()
class Location{
  Location({
            required this.name,
            required this.latitude, 
            required this.longitude,
            required this.type,
            required this.address,
            required this.laundry,
            required this.portableToilet,
            required this.restrooms,
            required this.showers,
            required this.accessibleBy,
            required this.population,
          });
  
  final String name;
  final double latitude;
  final double longitude;
  final String type;
  final String address;
  final String laundry;
  final String portableToilet;
  final String restrooms;
  final String showers;
  final String accessibleBy;
  final String population;

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  // Finds distance between our position and the venue's position
  // Params:
  //  - latitude: required double
  //  - longitude: required double
  // Returns: The distance between our position and the venue's position
  num distanceFrom({required double latitude, required double longitude}) {
    // Pythagorean theorem to calculate distance
    double distance = sqrt(_squared(this.latitude - latitude) + _squared(this.longitude - longitude));
    return distance;
  }

  // Calculates distance in meters our position and the venue's position
  // Params:
  //  - latitude: required double
  //  - longitude: required double
  // Returns: The distance in meters between our position and the venue's position
  num distanceInMeters({required double latitude, required double longitude}){
    // Math
    return 111139 * distanceFrom(latitude: latitude, longitude: longitude);
  }

  // Calculates the square of a number
  // Params:
  //  - x: num
  // Returns: The square of a number
  num _squared(num x) { return x * x; }
}