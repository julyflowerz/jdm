import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'cargame.dart'; // Create this file

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: CarGame());
  }
}
