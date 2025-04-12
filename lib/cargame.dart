import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'playercar.dart';
import 'package:flame/events.dart';

class CarGame extends FlameGame with HasKeyboardHandlerComponents {
  late SpriteComponent background;
  late SpriteComponent road;
  late PlayerCar playerCar;

  @override
  Future<void> onLoad() async {
    // Load background
    background = SpriteComponent()
      ..sprite = await loadSprite('mountains.png')
      ..size = size
      ..position = Vector2.zero();
    add(background);

    // Load road - takes 45% of screen height
    road = SpriteComponent()
      ..sprite = await loadSprite('road.png')
      ..size = Vector2(size.x, size.y * 0.45)
      ..position = Vector2(0, size.y * 0.55);
    add(road);

    // Load player car with proper class and aspect ratio
    final carSprite = await loadSprite('supra.png');
    final aspectRatio = carSprite.srcSize.x / carSprite.srcSize.y;

    playerCar = PlayerCar()
      ..sprite = carSprite
      ..size = Vector2(160, 160 / aspectRatio)
      ..position = Vector2(size.x * 0.1, size.y * 0.55 + 200);
    add(playerCar);
  }
}
