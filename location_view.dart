import 'package:flutter/material.dart';
import 'package:final_project_app/models/location.dart';
import 'package:final_project_app/providers/position_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationView extends StatelessWidget {
  // Location initialization
  final Location location;
  // Provider initialization
  final PositionProvider positionProvider;

  // Constructor
  const LocationView({
    super.key,
    required this.location,
    required this.positionProvider,
  });

  // Build widget, displays more information about one specific location
  // Parameters:
  //  - context: BuildContext
  // Returns widgets
  @override
  Widget build(BuildContext context) {
    // Text Widget
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          label: 'MORE INFO',
          child: const Text(
            'MORE INFO',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ),
      // Information widgets
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _locationInformation('Location Name', location.name),
            _locationInformation('Type', location.type),
            _locationInformation('Address', location.address),
            _locationInformation(
                'Distance',
                '${location.distanceInMeters(
                      latitude: positionProvider.latitude,
                      longitude: positionProvider.longitude,
                    ).roundToDouble().toString()} meters away'),
            _locationInformation('Available to', location.population),
            _locationInformation('Laundry Available', location.laundry),
            _locationInformation(
                'Portable Toilet Available', location.portableToilet),
            _locationInformation('Restroom Available', location.restrooms),
            _locationInformation('Showers Available', location.showers),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () =>
                  _openMapsApp(location.latitude, location.longitude),
              icon: Semantics(label: 'Open maps app for navigation' ,child: const Icon(Icons.navigation)),
              label: const Text('Navigate to this place', semanticsLabel: 'Navigate to this place',),
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
          ],
        ),
      ),
    );
  }

  // Helper widget to grab location information and display it using widgets, reduces redundancy
  // Parameters:
  //  - title: String
  //  - info: String
  // Returns widgets
  Widget _locationInformation(String title, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Semantics(
        label: '$title: $info',
        value: info,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$title: ',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Expanded(
              child: Text(info, style: const TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  void _openMapsApp(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
