import 'package:flame/components.dart';
import 'package:letter_to_santa/game/game.dart';

/// Компонент, отвечающий за физику движения: ускорение, торможение, ограничение скорости.
///
/// Все внутренние значения хранятся в нормализованных единицах —
/// «долях высоты экрана в секунду». Высота выбрана потому, что
/// размеры земли и поезда тоже привязаны к высоте экрана.
/// На экранах разных пропорций визуальная скорость будет одинаковой.
class MovementController extends Component with HasGameReference<LetterToSantaGame> {
  // Нормализованные константы (доли высоты экрана в секунду)
  static const double _maxSpeed = 0.4; // Максимальная скорость вперед
  static const double _minSpeed = -0.25; // Максимальная скорость назад
  static const double _acceleration = 1.0; // Ускорение / замедление

  /// Текущая скорость в нормализованных единицах
  double _speed = 0;

  bool isMovingForward = false;
  bool isMovingBackward = false;

  /// Текущая скорость в пикселях/сек (для использования другими компонентами)
  double get currentSpeed => _speed * game.size.y;

  void startMovingForward() {
    isMovingForward = true;
    isMovingBackward = false;
  }

  void startMovingBackward() {
    isMovingBackward = true;
    isMovingForward = false;
  }

  void stopMoving() {
    isMovingForward = false;
    isMovingBackward = false;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isMovingForward) {
      // Плавное ускорение вперед
      _speed += _acceleration * dt;
      if (_speed > _maxSpeed) _speed = _maxSpeed;
    } else if (isMovingBackward) {
      // Плавное ускорение назад
      _speed -= _acceleration * dt;
      if (_speed < _minSpeed) _speed = _minSpeed;
    } else {
      // Плавное замедление когда кнопки не нажаты
      if (_speed > 0) {
        _speed -= _acceleration * dt;
        if (_speed < 0) _speed = 0;
      } else if (_speed < 0) {
        _speed += _acceleration * dt;
        if (_speed > 0) _speed = 0;
      }
    }
  }
}
