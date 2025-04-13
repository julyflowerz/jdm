import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';
import 'playercar.dart';
import 'scoreservice.dart';

class CarGame extends FlameGame with HasKeyboardHandlerComponents {
  void Function()? onGameFinished;

  late SpriteComponent background;
  late SpriteComponent road;
  late PlayerCar playerCar;
  late SpriteComponent npcCar;
  late TextComponent countdownText;

  double score = 0;
  bool raceStarted = false;
  double npcTime = 0;
  double playerTime = 0;
  double npcSpeed = 80;

  @override
  Future<void> onLoad() async {
    background = SpriteComponent()
      ..sprite = await loadSprite('mountains.png')
      ..size = size
      ..position = Vector2.zero();
    add(background);

    road = SpriteComponent()
      ..sprite = await loadSprite('road.png')
      ..size = Vector2(size.x, size.y * 0.45)
      ..position = Vector2(0, size.y * 0.55);
    add(road);

    final carSprite = await loadSprite('supra.png');
    final aspectRatio = carSprite.srcSize.x / carSprite.srcSize.y;
    playerCar = PlayerCar()
      ..sprite = carSprite
      ..size = Vector2(160, 160 / aspectRatio)
      ..position = Vector2(size.x * 0.1, road.position.y + road.size.y - 160 / aspectRatio - 10);
    add(playerCar);

    final npcSprite = await loadSprite('r34.png');
    final npcAspect = npcSprite.srcSize.x / npcSprite.srcSize.y;
    npcCar = SpriteComponent()
      ..sprite = npcSprite
      ..size = Vector2(160, 160 / npcAspect)
      ..position = Vector2(size.x * 0.1, road.position.y + road.size.y - 160 / npcAspect - 10);
    add(npcCar);

    countdownText = TextComponent(
      text: '',
      position: Vector2(size.x / 2, size.y / 4),
      anchor: Anchor.center,
      priority: 10,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 48,
          color: BasicPalette.white.color,
          fontFamily: 'Arial',
        ),
      ),
    );
    add(countdownText);
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
          color: Color(0xFFFFFF00),
        ),
      ),
    );
    add(statsText);

    final scoreService = ScoreService();
    await scoreService.submitScore(winner, score.toInt());

    final playAgainText = PlayAgainText(reset)
      ..position = Vector2(size.x / 2, size.y * 0.75);
    add(playAgainText);

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
    onLoad(); // Reload everything
  }
}

// ✅ Mixin-safe tappable component
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
