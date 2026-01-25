import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:letter_to_santa/game/game.dart';

class ForestBackground extends ParallaxComponent<LetterToSantaGame> {
  @override
  Future<void> onLoad() async {
    priority = -10;
    parallax = await game.loadParallax(
      [
        ParallaxImageData('background/cloud-bg.png'),
        ParallaxImageData('background/cloud-1.png'),
        ParallaxImageData('background/cloud-2.png'),
        ParallaxImageData('background/cloud-3.png'),
        ParallaxImageData('background/cloud-4.png'),
        ParallaxImageData('background/forest-bg.png'),
        ParallaxImageData('background/forest-fg.png'),
      ],
      baseVelocity: Vector2.zero(),
      velocityMultiplierDelta: Vector2(1.4, 1.0),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Инвертируем знак, т.к. parallax работает наоборот
    // Положительная скорость игры -> отрицательная для parallax -> мир движется вправо
    parallax?.baseVelocity = Vector2(-game.currentSpeed / 10, 0);
  }
}
