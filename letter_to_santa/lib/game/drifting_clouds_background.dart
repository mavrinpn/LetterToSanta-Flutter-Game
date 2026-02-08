import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:letter_to_santa/game/game.dart';

/// Облака cloud-1..4 — независимый дрейф слева направо, не зависит от движения поезда.
class DriftingCloudsBackground extends ParallaxComponent<LetterToSantaGame> {
  /// Скорость дрейфа (доли высоты экрана в секунду).
  /// Положительная — облака плывут слева направо.
  static const double _driftSpeed = 0.03;

  /// Множитель между соседними слоями облаков
  static const double _layerSpeedMultiplier = 1.2;

  @override
  Future<void> onLoad() async {
    priority = -11; // позади ForestBackground
    parallax = await game.loadParallax(
      [
        ParallaxImageData('background/cloud-1.png'),
        ParallaxImageData('background/cloud-2.png'),
        ParallaxImageData('background/cloud-3.png'),
        ParallaxImageData('background/cloud-4.png'),
      ],
      baseVelocity: Vector2.zero(),
      velocityMultiplierDelta: Vector2(_layerSpeedMultiplier, 1.0),
    );
  }

  @override
  void update(double dt) {
    // Постоянный дрейф слева направо (знак инвертирован для parallax)
    parallax?.baseVelocity = Vector2(-game.size.y * _driftSpeed, 0);
    super.update(dt);
  }
}
