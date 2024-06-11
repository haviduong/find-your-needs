// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      type: json['type'] as String,
      address: json['address'] as String,
      laundry: json['laundry'] as String,
      portableToilet: json['portableToilet'] as String,
      restrooms: json['restrooms'] as String,
      showers: json['showers'] as String,
      accessibleBy: json['accessibleBy'] as String,
      population: json['population'] as String,
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'type': instance.type,
      'address': instance.address,
      'laundry': instance.laundry,
      'portableToilet': instance.portableToilet,
      'restrooms': instance.restrooms,
      'showers': instance.showers,
      'accessibleBy': instance.accessibleBy,
      'population': instance.population,
    };
