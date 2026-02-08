import 'package:flame/components.dart';
import 'package:letter_to_santa/game/game.dart';

enum TrainState { running, idle }

class Train extends SpriteGroupComponent<TrainState> with HasGameReference<LetterToSantaGame> {
  /// Доля высоты экрана, которую занимает поезд
  static const double trainHeightFraction = 0.30;

  /// Соотношение сторон спрайта поезда (ширина / высота оригинальной картинки)
  static const double _trainAspectRatio = 1107 / 505;

  /// Доля высоты поезда, на которую он «заходит» на землю (перекрытие колесами)
  static const double _groundOverlapFraction = 0.215;

  Train() : super(size: Vector2.zero());

  // Поезд стоит на месте в центре экрана (немного левее)
  double get trainXPosition => game.size.x * 0.4;
  double get groundYPosition =>
      game.forestForeground.y - height * (1 - _groundOverlapFraction);

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

    // Размер поезда пропорционален высоте экрана
    final trainHeight = size.y * trainHeightFraction;
    this.size = Vector2(trainHeight * _trainAspectRatio, trainHeight);

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
