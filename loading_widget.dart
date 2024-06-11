import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  // Constructor
  const LoadingWidget({
    super.key,
  });

  // Build widget to display widgets
  // Parameters:
  //  - context: BuildContext
  // Return widgets
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Loading Current Location',
        style: TextStyle(
          color: Color.fromARGB(255, 24, 114, 21),
          decoration: TextDecoration.none,
          fontSize: 50,
          fontWeight: FontWeight.bold
        ),
        semanticsLabel: 'Loading Current Location',
      )
    );
  }
}
