import 'package:flame/components.dart';
import 'package:letter_to_santa/game/game.dart';

enum TrainState { running, idle }

class Train extends SpriteGroupComponent<TrainState> with HasGameReference<LetterToSantaGame> {
  Train() : super(size: Vector2(1107 / 2, 505 / 2));

  double get startXPosition => game.forestForeground.width + width;
  double get groundYPosition => game.forestForeground.y - height + 428;

  @override
  void onLoad() {
    super.onLoad();
    sprites = {
      TrainState.running: Sprite(game.images.fromCache('train.png')),
      TrainState.idle: Sprite(game.images.fromCache('train.png')),
    };
    current = TrainState.idle;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    x = startXPosition;
    y = groundYPosition;
  }
}
