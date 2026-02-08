import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:letter_to_santa/game/game.dart';

/// cloud-bg.png — самый дальний слой, привязан к скорости поезда.
class CloudBgBackground extends ParallaxComponent<LetterToSantaGame> {
  static const double _baseSpeedFraction = 0.1;

  @override
  Future<void> onLoad() async {
    priority = -12; // позади дрейфующих облаков
    parallax = await game.loadParallax(
      [ParallaxImageData('background/cloud-bg.png')],
      baseVelocity: Vector2.zero(),
    );
  }

  @override
  void update(double dt) {
    parallax?.baseVelocity = Vector2(-game.currentSpeed * _baseSpeedFraction, 0);
    super.update(dt);
  }
}
