import 'package:flutter/material.dart';
import 'package:final_project_app/models/location.dart';
import 'package:final_project_app/providers/position_provider.dart';

class LocationWidget extends StatelessWidget {
  // Location initialization
  final Location location;
  // Provider initialization
  final PositionProvider positionProvider;

  // Constructor
  const LocationWidget({
    super.key,
    required this.location,
    required this.positionProvider,
  });

  // Build widget, displays simplified information about one specific location
  // Parameters:
  //  - context: BuildContext
  // Returns Widgets
  @override
  Widget build(BuildContext context) {
    // Location's icon associated with its type
    Semantics widgetIcon = Semantics(label: 'Unknown', child: const Icon(Icons.question_mark));
    switch(location.type) {
      case 'Restroom':
        widgetIcon = Semantics(label: 'Restroom available at location', child: const Icon(Icons.family_restroom, color: Colors.blue));
        break;
      case 'General Hygiene':
        widgetIcon = Semantics(label: 'General hygiene stations available at location. Example: Shower, Restrooms and Laundry', child: const Icon(Icons.bathtub, color: Colors.purple));
        break;
      case 'Library':
        widgetIcon = Semantics(label: 'Library', child: const Icon(Icons.local_library, color: Colors.orange));
        break;
      case 'Food Bank':
        widgetIcon = Semantics(label: 'Food Bank', child: const Icon(Icons.food_bank, color: Colors.green));
        break;
    }
    // Location information
    return Column(
      children: <Widget>[
        ListTile(
          leading: Semantics(
            label: location.type,
            child: widgetIcon
          ),
          title: Semantics(
            label: location.name,
            child: Text(location.name)),
          subtitle: Semantics(
            label: location.type,
            child: Text(location.type)),
          trailing: Semantics(
            label: '${location.distanceInMeters(latitude: positionProvider.latitude, longitude: positionProvider.longitude).roundToDouble().toString()} meters',
            child: Text('${location.distanceInMeters(latitude: positionProvider.latitude, longitude: positionProvider.longitude).roundToDouble().toString()} meters'))
        ),
      ],
    );
  }
}