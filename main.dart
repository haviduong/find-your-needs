import 'package:final_project_app/models/locations_db.dart';
import 'package:final_project_app/providers/position_provider.dart';
import 'package:final_project_app/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Handles obtaining locations from the JSON file.
Future<LocationsDB> loadLocationsDB(String dataPath) async {
  return LocationsDB.initializeFromJson(await rootBundle.loadString(dataPath));
}

// Obtains locations from the JSON file to display in the app
void main() {
  // Path to json file
  const dataPath = 'assets/locations.json';
  // Initializing widgets
  WidgetsFlutterBinding.ensureInitialized();
  // Grabs location data and displays in the app
  loadLocationsDB(dataPath).then((value) => runApp(
        // Grabs provider
        ChangeNotifierProvider(
          create: (context) => PositionProvider(),
          // Main app widget
          child: MainApp(locations: value),
        ),
      ));
}

// Main widget for holding app views, and other widget trees
class MainApp extends StatelessWidget {
  // Storing locations database
  final LocationsDB locations;

  // Constructor
  const MainApp({super.key, required this.locations});

  // Build widget
  // Parameters:
  // - context: BuildContext
  // Returns a widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(locations: locations),
    );
  }
}
