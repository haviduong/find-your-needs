import 'package:flutter/material.dart';
import 'find_your_needs_app.dart';
import 'package:final_project_app/models/locations_db.dart';

class HomePage extends StatelessWidget {
  final LocationsDB locations; // Declaring an instance variable to store the LocationsDB object

  // Constructor:
  // Accepts a key parameter and a locations parameter
  const HomePage({super.key, required this.locations});

  // Overrides the build method to define the widget tree.
  // Parameters:
  //   - context: The BuildContext object representing the location of the widget in the tree.
  // Returns a Scaffold widget with a white background color and a centered Column.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // title
            const Text(
              'FIND\nYOUR\nNEEDS',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              semanticsLabel: 'Find Your Needs',
            ),
            const SizedBox(height: 40),
            // row of icons representing the different needs icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // current location icon
                Semantics(
                  label: 'Current Location',
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 20),
                // restroom icon
                Semantics(
                  label: 'Restroom',
                  child: const Icon(
                    Icons.family_restroom,
                    color: Colors.blue,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 20),
                // general hygiene icon
                Semantics(
                  label: 'General Hygiene',
                  child: const Icon(
                    Icons.bathtub,
                    color: Colors.purple,
                    size: 40,
                    semanticLabel: 'General Hygiene',
                  ),
                ),
                const SizedBox(width: 20),
                // library icon
                Semantics(
                  label: 'Library',
                  child: const Icon(
                    Icons.local_library,
                    color: Colors.orange,
                    size: 40,
                    semanticLabel: 'Library',
                  ),
                ),
                const SizedBox(width: 20),
                // food bank icon
                Semantics(
                  label: 'Food Bank',
                  child: const Icon(
                    Icons.food_bank,
                    color: Colors.green,
                    size: 40,
                    semanticLabel: 'Food Bank',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // start search button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to the next page (map page)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FindYourNeedsApp(locations: locations),
                    ),
                  );
                },
                icon: const Icon(Icons.touch_app),
                label: const Text(
                  'START SEARCH',
                  style: TextStyle(fontSize: 18),
                  semanticsLabel: 'Start Search',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(200, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
