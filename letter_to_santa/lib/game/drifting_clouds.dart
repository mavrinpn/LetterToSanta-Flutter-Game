import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:letter_to_santa/game/game.dart';

/// Облака cloud-1..4, плывут слева направо независимо от движения поезда.
class DriftingClouds extends ParallaxComponent<LetterToSantaGame> {
  /// Постоянная скорость дрейфа (доли высоты экрана в секунду).
  /// Положительная = облака плывут слева направо.
  static const double _driftSpeed = 0.02;

  static const double _layerSpeedMultiplier = 1.4;

  @override
  Future<void> onLoad() async {
    priority = -9;
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
    parallax?.baseVelocity = Vector2(
      -game.size.y * _driftSpeed,
      0,
    );
    super.update(dt);
  }
}
