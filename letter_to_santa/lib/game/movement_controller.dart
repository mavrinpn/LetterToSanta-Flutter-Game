import 'package:flame/components.dart';

/// Компонент, отвечающий за физику движения: ускорение, торможение, ограничение скорости.
class MovementController extends Component {
  static const double maxSpeed = 300.0; // Максимальная скорость вперед (влево)
  static const double minSpeed = -200.0; // Максимальная скорость назад (вправо)
  static const double acceleration = 500.0; // Ускорение / замедление

  double currentSpeed = 0;
  bool isMovingForward = false;
  bool isMovingBackward = false;

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
      currentSpeed += acceleration * dt;
      if (currentSpeed > maxSpeed) currentSpeed = maxSpeed;
    } else if (isMovingBackward) {
      // Плавное ускорение назад
      currentSpeed -= acceleration * dt;
      if (currentSpeed < minSpeed) currentSpeed = minSpeed;
    } else {
      // Плавное замедление когда кнопки не нажаты
      if (currentSpeed > 0) {
        currentSpeed -= acceleration * dt;
        if (currentSpeed < 0) currentSpeed = 0;
      } else if (currentSpeed < 0) {
        currentSpeed += acceleration * dt;
        if (currentSpeed > 0) currentSpeed = 0;
      }
    }
  }
}
