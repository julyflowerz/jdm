import 'package:flutter/material.dart';
import 'gamescreen.dart'; // Imports the main game screen to navigate to

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
              'assets/images/background.gif',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/carlist');
              },
              // 👇 This was misplaced before
              child: Image.asset(
                'assets/images/start.png',
                width: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
