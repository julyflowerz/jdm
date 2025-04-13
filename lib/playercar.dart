import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'cargame.dart';

class PlayerCar extends SpriteComponent with KeyboardHandler, HasGameRef<CarGame> {
  double speed = 0;
  final double maxSpeed = 200;

  @override
  void update(double dt) {
    super.update(dt);

    if (!gameRef.raceStarted) return;

    position.x += speed * dt;

    // Restrict going off the left side only
    if (position.x < 0) {
      position.x = 0;
    }

    // ✅ No right-side restriction — player can win
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD)) {
      speed = maxSpeed;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA)) {
      speed = -maxSpeed;
    } else {
      speed = 0;
    }

    return true;
  }
}
