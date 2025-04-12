import 'package:flutter/material.dart';
import 'gamescreen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image fills the screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.gif',
              fit: BoxFit.cover,
            ),
          ),
          // "Press Start" button in the center
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GameScreen()),
                );
              },
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
