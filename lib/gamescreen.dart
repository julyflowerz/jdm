import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'cargame.dart';             // Imports your main game logic (Flame game)
import 'leaderboardscreen.dart'; // Imports the leaderboard Flutter screen

// The GameScreen is a full-screen widget that renders your Flame game
class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create an instance of your custom Flame game
    final carGame = CarGame();

    // 🔁 Attach a callback that runs when the game ends
    // Used to navigate to the leaderboard from inside the game
    carGame.onGameFinished = () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
      );
    };

    return Scaffold(
      body: GameWidget(
        game: carGame, // Embeds the Flame game inside a Flutter widget
        overlayBuilderMap: {
          // Optional overlays (not used here but ready for future use)
          'Leaderboard': (context, _) => const LeaderboardScreen(),
        },
      ),
    );
  }
}
