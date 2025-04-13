import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'cargame.dart';
import 'leaderboardscreen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final carGame = CarGame();

    // Attach callback to show leaderboard after race ends
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
