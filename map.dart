import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'location.dart';
import 'location_service.dart';
import '/providers/position_provider.dart';
import 'package:final_project_app/views/legend.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  // makes the state for the MapScreen
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  // final LatLng _center = const LatLng(47.6062, -122.3321); // using Paul Allen as center
  List<Marker> _markers = [];
  double _currentZoom = 11.0;
  LatLng _currentCenter = const LatLng(47.6062, -122.3321);

  @override
  void initState() {
    super.initState();
    // save map postoion
    _loadMapPosition();
  }

  // Callback when the map is created
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _loadMarkers();
    _loadMapPosition();
  }

  // load markers from a JSON file
  Future<void> _loadMarkers() async {
    List<Location> locations = await loadLocations();
    Set<Marker> markers = {};
    for (Location location in locations) {
      // Get custom icon for marker
      final BitmapDescriptor markerIcon = await _getIconForType(location.type);
      markers.add(
        Marker(
          markerId: MarkerId(location.name),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(
            title: location.name,
            snippet: location.address,
          ),
          icon: markerIcon,
        ),
      );
    }

    setState(() {
      // updates the state with the loaded markers
      _markers = markers.toList();
    });
  }

  // Function to get a custom icon based on the location type
  Future<BitmapDescriptor> _getIconForType(String type) async {
    IconData iconData;
    Color iconColor;
    switch (type) {
      case 'Restroom':
        iconData = Icons.family_restroom;
        iconColor = Colors.blue;
        break;
      case 'General Hygiene':
        iconData = Icons.bathtub;
        iconColor = Colors.purple;
        break;
      case 'Library':
        iconData = Icons.local_library;
        iconColor = Colors.orange;
        break;
      case 'Food Bank':
        iconData = Icons.food_bank;
        iconColor = Colors.green;
        break;
      default:
        iconData = Icons.question_mark;
        iconColor = Colors.black;
    }
    return await _createCustomMarkerBitmap(iconData, iconColor);
  }

  // creates a custom marker bitmap
  Future<BitmapDescriptor> _createCustomMarkerBitmap(
      IconData iconData, Color color) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double size = 80.0;
    const double iconSize = 60.0;

    final Paint paint = Paint()..color = color; // used the color param here
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2,
      paint,
    );

    // front end changes
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: iconSize,
        fontFamily: iconData.fontFamily,
        color: Colors.white,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size - textPainter.width) / 2,
        (size - textPainter.height) / 2,
      ),
    );

    final img = await pictureRecorder
        .endRecording()
        .toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ImageByteFormat.png);
    // Return custom marker bitmap
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  // zoom in
  void _zoomIn() {
    setState(() {
      _currentZoom++;
      mapController.animateCamera(CameraUpdate.zoomIn());
      _saveMapPosition();
    });
  }

  // zoom out
  void _zoomOut() {
    setState(() {
      _currentZoom--;
      mapController.animateCamera(CameraUpdate.zoomOut());
      _saveMapPosition();
    });
  }

  // saves the current map position and zoom level
  Future<void> _saveMapPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', _currentCenter.latitude);
    await prefs.setDouble('longitude', _currentCenter.longitude);
    await prefs.setDouble('zoom', _currentZoom);
  }

  // loads the saved map position and zoom level
  Future<void> _loadMapPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');
    double? zoom = prefs.getDouble('zoom');

    if (latitude != null && longitude != null && zoom != null) {
      setState(() {
        _currentCenter = LatLng(latitude, longitude);
        _currentZoom = zoom;
      });
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentCenter, zoom: _currentZoom),
      ));
    }
  }

  // current location button caller
  void _goToCurrentLocation(PositionProvider positionProvider) {
    final currentLocation =
        LatLng(positionProvider.latitude, positionProvider.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(currentLocation));
    setState(() {
      _currentCenter = currentLocation;
      _currentZoom = -15.0; // zoom level with button
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Consumer<PositionProvider>(
            builder: (context, positionProvider, child) {
              if (positionProvider.positionKnown) {
                final currentLocationMarker = Marker(
                  markerId: const MarkerId('current_location'),
                  position: LatLng(
                      positionProvider.latitude, positionProvider.longitude),
                  infoWindow: const InfoWindow(
                    title: 'Current Location',
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                );
                final allMarkers = Set<Marker>.of(_markers)
                  ..add(currentLocationMarker);

                return GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _currentCenter,
                    zoom: _currentZoom,
                  ),
                  onCameraMove: (CameraPosition position) {
                    _currentCenter = position.target;
                    _currentZoom = position.zoom;
                  },
                  onCameraIdle: () {
                    _saveMapPosition();
                  },
                  markers: allMarkers,
                  myLocationButtonEnabled: false,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Positioned(
            bottom: 80,
            right: 16,
            child: Column(
              children: [
                Semantics(
                  label: 'Zoom In',
                  child: _buildZoomButton(Icons.add, _zoomIn),
                ),
                const SizedBox(height: 8),
                Semantics(
                  label: 'Zoom Out',
                  child: _buildZoomButton(Icons.remove, _zoomOut),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 4.0,
              child: InkWell(
                onTap: () {
                  final positionProvider =
                      Provider.of<PositionProvider>(context, listen: false);
                  _goToCurrentLocation(positionProvider);
                },
                customBorder: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.my_location, size: 32, color: Colors.black),
                ),
              ),
            ),
          ),

          const Positioned(
            left: 16,
            bottom: 16,
            child: LegendWidget(),
          ),
        ],
      ),
    );
  }

  // Function to build zoom buttons
  Widget _buildZoomButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 4.0,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, size: 32, color: Colors.black),
        ),
      ),
    );
  }
}
