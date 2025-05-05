import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'cargame.dart';             // Imports your Flame game logic
import 'leaderboardscreen.dart'; // For leaderboard display
import 'car_model.dart';         // Car model (with make/model/spritePath)

class GameScreen extends StatelessWidget {
  final Car car;

  const GameScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final carGame = CarGame(car: car); // Pass selected car

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
