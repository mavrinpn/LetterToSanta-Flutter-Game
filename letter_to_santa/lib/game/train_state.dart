import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:letter_to_santa/game/game.dart';

enum TrainState { running, idle }

class Train extends SpriteGroupComponent<TrainState>
    with HasGameReference<LetterToSantaGame>, DragCallbacks {
  /// Доля высоты экрана, которую занимает поезд
  static const double trainHeightFraction = 0.30;

  /// Соотношение сторон спрайта поезда (ширина / высота оригинальной картинки)
  static const double _trainAspectRatio = 1107 / 505;

  /// Доля высоты поезда, на которую он «заходит» на землю (перекрытие колесами)
  static const double _groundOverlapFraction = 0.215;

  /// Отступ от краёв экрана при перетаскивании
  static const double _dragPaddingFraction = 0.05;

  Train() : super(size: Vector2.zero());

  /// Позиция по умолчанию (центр чуть левее)
  double get trainXPosition => game.size.x * 0.4;
  double get groundYPosition =>
      game.forestForeground.y - height * (1 - _groundOverlapFraction);

  double get _minX => game.size.x * _dragPaddingFraction;
  double get _maxX => game.size.x * (1 - _dragPaddingFraction) - width;

  /// Ручная позиция при перетаскивании (null = использовать trainXPosition)
  double? _manualX;

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

    // При ресайзе пересчитываем _manualX в границах
    if (_manualX != null) {
      _manualX = _manualX!.clamp(_minX, _maxX);
    }
    x = _manualX ?? trainXPosition;
    y = groundYPosition;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _manualX = (x + event.canvasDelta.x).clamp(_minX, _maxX);
    x = _manualX!;
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

    x = _manualX ?? trainXPosition;
    y = groundYPosition;
  }
}
