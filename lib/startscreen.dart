import 'package:flutter/material.dart';
import 'gamescreen.dart'; // Imports the main game screen to navigate to
import 'car_selection_screen.dart';

// StartScreen is a stateless widget shown when the app starts
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image that fills the entire screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.gif', // Make sure this asset exists in pubspec.yaml
              fit: BoxFit.cover,               // Ensures it scales to cover the whole screen
            ),
          ),
          // Centered "Press Start" button
          Center(
            child: GestureDetector(
              // When tapped, navigate to the actual game screen
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CarSelectionScreen()),
                );

              },
              // The button is an image (styled like a "Start" graphic)
              child: Image.asset(
                'assets/images/start.png', // Make sure this asset exists too
                width: 200,                // Scales the image size
              ),
            ),
          ),
        ],
      ),
    );
  }
}
