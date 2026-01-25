import 'package:flame/components.dart';
import 'package:letter_to_santa/game/game.dart';

enum TrainState { running, idle }

class Train extends SpriteGroupComponent<TrainState> with HasGameReference<LetterToSantaGame> {
  Train() : super(size: Vector2(1107 / 2, 505 / 2));

  // Поезд стоит на месте в центре экрана (немного левее)
  double get trainXPosition => game.size.x * 0.4;
  double get groundYPosition => game.forestForeground.y - height + 70;

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
    x = trainXPosition;
    y = groundYPosition;
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Обновляем состояние поезда в зависимости от скорости
    if (game.currentSpeed != 0) {
      current = TrainState.running;
    } else {
      current = TrainState.idle;
    }
    
    // Поезд остается на месте, не двигается
    x = trainXPosition;
    y = groundYPosition;
  }
}
