import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  // Constructor
  const HeaderWidget({
    super.key,
    required this.locationWidgets,
  });

  // List of locations
  final List<Widget> locationWidgets;

  // Widget to display list widgets of locations
  // Parameters:
  //  - context: BuildContext
  // Returns widgets
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: locationWidgets,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}