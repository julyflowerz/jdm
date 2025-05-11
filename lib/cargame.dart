
// Core drawing and graphics from Flutter
import 'dart:ui';

// Flame game engine core
import 'package:flame/game.dart';
import 'package:flame/components.dart';         // For sprites and text
import 'package:flame/events.dart';             // For tap/click/keyboard handlers
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore (database)
import 'package:flame/palette.dart';            // Predefined colors
import 'package:flame/text.dart';               // Flame text rendering
import 'package:flutter/material.dart';

// Your custom components/services
import 'playercar.dart';                        // Your player car logic
import 'scoreservice.dart';                     // Handles saving score to Firebase
import 'car_model.dart';

class CarGame extends FlameGame with HasKeyboardHandlerComponents {
  final Car selectedCar;

  CarGame(this.selectedCar);

  // Optional callback to switch to another screen (e.g. leaderboard)
  void Function()? onGameFinished;

  // Components used in the game
  late SpriteComponent background;
  late SpriteComponent road;
  late PlayerCar playerCar;
  late SpriteComponent npcCar;
  late TextComponent countdownText;

  // Game state tracking
  double score = 0;
  bool raceStarted = false;
  double npcTime = 0;
  double playerTime = 0;
  double npcSpeed = 80;

  // This runs once when the game starts (loads assets, sets up positions)
  @override
  @override
  Future<void> onLoad() async {
    // Load and scale background without distortion
    final bgSprite = await loadSprite('white.png');
    final bgAspectRatio = bgSprite.srcSize.x / bgSprite.srcSize.y;

    final bgWidth = size.x;
    final bgHeight = bgWidth / bgAspectRatio;

    if (bgHeight < size.y) {
      final newHeight = size.y;
      final newWidth = newHeight * bgAspectRatio;

      background = SpriteComponent()
        ..sprite = bgSprite
        ..size = Vector2(newWidth, newHeight)
        ..position = Vector2((size.x - newWidth) / 2, 0);
    } else {
      background = SpriteComponent()
        ..sprite = bgSprite
        ..size = Vector2(bgWidth, bgHeight)
        ..position = Vector2(0, (size.y - bgHeight) / 2);
    }

    add(background);

    // Load and add road sprite
    road = SpriteComponent()
      ..sprite = await loadSprite('road.png')
      ..size = Vector2(size.x, size.y * 0.45)
      ..position = Vector2(0, size.y * 0.55);
    add(road);

    // Load and position player car using selectedCar.sprite
    final carSprite = await loadSprite(selectedCar.sprite);
    final aspectRatio = carSprite.srcSize.x / carSprite.srcSize.y;
    playerCar = PlayerCar()
      ..sprite = carSprite
      ..size = Vector2(160, 160 / aspectRatio)
      ..position = Vector2(
        size.x * 0.1,
        road.position.y + road.size.y - 250,
      );
    add(playerCar);

    // Load and position NPC car
    final npcSprite = await loadSprite('skyline.png');
    final npcAspect = npcSprite.srcSize.x / npcSprite.srcSize.y;
    npcCar = SpriteComponent()
      ..sprite = npcSprite
      ..size = Vector2(160, 160 / npcAspect)
      ..position = Vector2(size.x * 0.1, road.position.y + road.size.y - 180 / npcAspect);
    add(npcCar);

    // Countdown setup
    countdownText = TextComponent(
      text: '',
      position: Vector2(size.x / 2, size.y / 4),
      anchor: Anchor.center,
      priority: 10,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 48,
          color: Colors.black,
          fontFamily: 'Arial',
        ),
      ),
    );
    add(countdownText);

    // Start countdown
    startCountdown();
  }


  void startCountdown() async {
    for (int i = 5; i > 0; i--) {
      countdownText.text = '$i';
      await Future.delayed(const Duration(seconds: 1));
    }
    countdownText.text = 'GO!';
    raceStarted = true;
    await Future.delayed(const Duration(seconds: 1));
    remove(countdownText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!raceStarted) return;

    score += dt;
    playerTime += dt;
    npcTime += dt;

    npcCar.position.x += npcSpeed * dt;

    final finishLineX = size.x - playerCar.size.x;

    if (playerCar.position.x > finishLineX) {
      raceStarted = false;
      showWinner('You');
    } else if (npcCar.position.x > finishLineX) {
      raceStarted = false;
      showWinner('NPC');
    }
  }

  void showWinner(String winner) async {
    // Create a semi-transparent black box behind the text
    final box = RectangleComponent(
      size: Vector2(size.x * 0.6, size.y * 0.3),
      position: Vector2(size.x / 2, size.y / 3),
      anchor: Anchor.center,
      paint: Paint()..color = const Color.fromARGB(180, 0, 0, 0), // translucent black
      priority: 19, // Lower than statsText to appear behind
    );
    add(box);

    // Show race results on top of the box
    final statsText = TextComponent(
      text: """
$winner won!
User Time: ${playerTime.toStringAsFixed(2)}s
NPC Time: ${npcTime.toStringAsFixed(2)}s
User Speed: ${playerCar.speed.toStringAsFixed(2)} px/s
""",
      position: Vector2(size.x / 2, size.y / 3),
      anchor: Anchor.center,
      priority: 20,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 24,
          color: Colors.yellow,
          fontFamily: 'Courier',
          height: 1.3,
        ),
      ),
    );
    add(statsText);

    // Save score to Firebase
    final scoreService = ScoreService();
    await scoreService.submitScore(winner, playerTime);

    // Add Play Again button
    final playAgainText = PlayAgainText(reset)
      ..position = Vector2(size.x / 2, size.y * 0.75);
    add(playAgainText);

    // Wait 5 seconds before switching to leaderboard
    await Future.delayed(const Duration(seconds: 5));
    if (onGameFinished != null) {
      onGameFinished!();
    }
  }


  void reset() {
    children.clear();
    score = 0;
    raceStarted = false;
    playerTime = 0;
    npcTime = 0;
    onLoad();
  }
}

class PlayAgainText extends TextComponent with TapCallbacks {
  final VoidCallback onTap;

  PlayAgainText(this.onTap)
      : super(
    text: 'Tap to Play Again',
    anchor: Anchor.center,
    priority: 30,
    textRenderer: TextPaint(
      style: TextStyle(fontSize: 30, color: Color(0xFF00FF00)),
    ),
  );

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}
