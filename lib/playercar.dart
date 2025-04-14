// Flame component base for drawing the car sprite
import 'package:flame/components.dart';
// Handles keyboard events (arrow keys, WASD, etc.)
import 'package:flame/input.dart';
// Flutter keyboard key constants
import 'package:flutter/services.dart';
// Import the game so we can access gameRef.raceStarted
import 'cargame.dart';

// Your custom player car class
class PlayerCar extends SpriteComponent
    with KeyboardHandler, HasGameRef<CarGame> {
  double speed = 0;               // Current speed of the car
  final double maxSpeed = 200;    // Max horizontal speed

  @override
  void update(double dt) {
    super.update(dt);

    // Don’t allow movement unless race has started
    if (!gameRef.raceStarted) return;

    // Move horizontally based on current speed
    position.x += speed * dt;

    // Prevent car from going off the left side of the screen
    if (position.x < 0) {
      position.x = 0;
    }

    // 🔓 Right side is intentionally not restricted — player can win the race
  }

  // Handle keyboard input (WASD or arrow keys)
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD)) {
      speed = maxSpeed; // Move right
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA)) {
      speed = -maxSpeed; // Move left
    } else {
      speed = 0; // Stop when no keys are pressed
    }

    return true; // Let Flame know we handled the key input
  }
}
