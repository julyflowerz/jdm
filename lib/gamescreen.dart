import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'cargame.dart';             // Your custom Flame game class
import 'leaderboardscreen.dart'; // The leaderboard screen
import 'car_model.dart';          // Your Car model

class GameScreen extends StatelessWidget {
  final Car selectedCar;

  const GameScreen({super.key, required this.selectedCar});

  @override
  Widget build(BuildContext context) {
    // Initialize the Flame game with the selected car
    final carGame = CarGame(selectedCar);

    // Attach callback to move to leaderboard
    carGame.onGameFinished = () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
      );
    };

    return Scaffold(
      body: GameWidget(
        game: carGame,
        overlayBuilderMap: {
          'Leaderboard': (context, _) => const LeaderboardScreen(),
        },
      ),
    );
  }
}
