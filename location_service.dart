import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'location.dart';

// Function to load locations from a JSON file
Future<List<Location>> loadLocations() async {
  // Load the JSON file as a string from the assets directory
  final String response = await rootBundle.loadString('assets/locations.json');
  final data = json.decode(response) as List;
  // turns it into a list of Location objects
  return data.map((item) => Location.fromJson(item)).toList();
}
