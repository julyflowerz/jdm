// Core drawing and graphics from Flutter
import 'dart:ui';

// Flame game engine core
import 'package:flame/game.dart';
import 'package:flame/components.dart';         // For sprites and text
import 'package:flame/events.dart';             // For tap/click/keyboard handlers
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore (database)
import 'package:flame/palette.dart';            // Predefined colors
import 'package:flame/text.dart';               // Flame text rendering

// Your custom components/services
import 'playercar.dart';                        // Your player car logic
import 'scoreservice.dart';                     // Handles saving score to Firebase

// Main game class
class CarGame extends FlameGame with HasKeyboardHandlerComponents {
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
  Future<void> onLoad() async {
    // Load and add mountain background
    background = SpriteComponent()
      ..sprite = await loadSprite('mountains.png')
      ..size = size
      ..position = Vector2.zero();
    add(background);

    // Load and add road sprite
    road = SpriteComponent()
      ..sprite = await loadSprite('road.png')
      ..size = Vector2(size.x, size.y * 0.45)         // 45% screen height
      ..position = Vector2(0, size.y * 0.55);         // Starts at 55%
    add(road);

    // Load and position player car
    final carSprite = await loadSprite('supra.png');
    final aspectRatio = carSprite.srcSize.x / carSprite.srcSize.y;
    playerCar = PlayerCar()
      ..sprite = carSprite
      ..size = Vector2(160, 160 / aspectRatio)
      ..position = Vector2(size.x * 0.1, road.position.y + road.size.y - 190 / aspectRatio);
    add(playerCar);

    // Load and position NPC car
    final npcSprite = await loadSprite('r34.png');
    final npcAspect = npcSprite.srcSize.x / npcSprite.srcSize.y;
    npcCar = SpriteComponent()
      ..sprite = npcSprite
      ..size = Vector2(160, 160 / npcAspect)
      ..position = Vector2(size.x * 0.1, road.position.y + road.size.y - 180 / npcAspect);
    add(npcCar);

    // Show countdown at the start
    countdownText = TextComponent(
      text: '',
      position: Vector2(size.x / 2, size.y / 4),     // Center-top
      anchor: Anchor.center,
      priority: 10,                                  // On top of other components
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 48,
          color: BasicPalette.white.color,
          fontFamily: 'Arial',
        ),
      ),
    );
    add(countdownText);

    // Start the countdown
    startCountdown();
  }

  // Countdown before race starts
  void startCountdown() async {
    for (int i = 5; i > 0; i--) {
      countdownText.text = '$i';
      await Future.delayed(const Duration(seconds: 1));
    }
    countdownText.text = 'GO!';
    raceStarted = true; // Let cars move
    await Future.delayed(const Duration(seconds: 1));
    remove(countdownText); // Clear the countdown
  }

  // Runs every frame
  @override
  void update(double dt) {
    super.update(dt);

    if (!raceStarted) return;

    // Accumulate race time
    score += dt;
    playerTime += dt;
    npcTime += dt;

    // NPC car moves automatically
    npcCar.position.x += npcSpeed * dt;

    // Finish line detection
    final finishLineX = size.x - playerCar.size.x;

    if (playerCar.position.x > finishLineX) {
      raceStarted = false;
      showWinner('You');
    } else if (npcCar.position.x > finishLineX) {
      raceStarted = false;
      showWinner('NPC');
    }
  }

  // Called when someone wins the race
  void showWinner(String winner) async {
    // Show post-race stats
    final statsText = TextComponent(
      text: '''
$winner won!
User Time: ${playerTime.toStringAsFixed(2)}s
NPC Time: ${npcTime.toStringAsFixed(2)}s
User Speed: ${playerCar.speed.toStringAsFixed(2)} px/s
''',
      position: Vector2(size.x / 2, size.y / 3),
      anchor: Anchor.center,
      priority: 20,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 28,
          color: Color(0xFFFFFF00), // Yellow
        ),
      ),
    );
    add(statsText);

    // Save score to Firestore using ScoreService
    final scoreService = ScoreService();
    await scoreService.submitScore(winner, score.toInt());

    // Show "Play Again" button
    final playAgainText = PlayAgainText(reset)
      ..position = Vector2(size.x / 2, size.y * 0.75); // Lower part of screen
    add(playAgainText);

    // Notify app to show leaderboard if callback exists
    if (onGameFinished != null) {
      onGameFinished!();
    }
  }

  // Resets the game to play again
  void reset() {
    children.clear();     // Clear all sprites/components
    score = 0;
    raceStarted = false;
    playerTime = 0;
    npcTime = 0;
    onLoad();             // Reload everything
  }
}

//  Button component with tap logic
class PlayAgainText extends TextComponent with TapCallbacks {
  final VoidCallback onTap;

  PlayAgainText(this.onTap)
      : super(
    text: 'Tap to Play Again',
    anchor: Anchor.center,
    priority: 30,
    textRenderer: TextPaint(
      style: TextStyle(fontSize: 30, color: Color(0xFF00FF00)), // Green
    ),
  );

  // What happens when tapped
  @override
  void onTapDown(TapDownEvent event) {
    onTap(); // Calls reset()
  }
}
