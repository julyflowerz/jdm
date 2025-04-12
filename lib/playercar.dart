import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/events.dart'; // ✅ required
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';


class PlayerCar extends SpriteComponent with KeyboardHandler, HasGameRef {
  double speed = 0;
  final double maxSpeed = 200;
  final double acceleration = 150;

  late Vector2 gameSize;

  @override
  Future<void> onMount() async {
    super.onMount();
    gameSize = gameRef.size;
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.x += speed * dt;

    if (position.x < 0) position.x = 0;
    if (position.x + size.x > gameSize.x) {
      position.x = gameSize.x - size.x;
    }
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

    return true; // ✅ returns bool, not KeyEventResult
  }


}
