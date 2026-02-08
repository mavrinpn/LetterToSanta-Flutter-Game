import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:letter_to_santa/game/game.dart';

/// forest-bg.png, forest-fg.png — привязаны к скорости поезда.
class ForestBackground extends ParallaxComponent<LetterToSantaGame> {
  /// Скорость forest-bg относительно земли (согласовано с forestForeground).
  /// forest-bg: 0.54x, forest-fg: 0.75x (через multiplier 1.4)
  static const double _baseSpeedFraction = 0.54;

  /// Множитель между forest-bg и forest-fg
  static const double _layerSpeedMultiplier = 1.4;

  @override
  Future<void> onLoad() async {
    priority = -10;
    parallax = await game.loadParallax(
      [
        ParallaxImageData('background/forest-bg.png'),
        ParallaxImageData('background/forest-fg.png'),
      ],
      baseVelocity: Vector2.zero(),
      velocityMultiplierDelta: Vector2(_layerSpeedMultiplier, 1.0),
    );
  }

  @override
  void update(double dt) {
    // Сначала обновляем скорость, потом двигаем слои —
    // иначе параллакс отстаёт на один кадр при ускорении/торможении
    parallax?.baseVelocity = Vector2(-game.currentSpeed * _baseSpeedFraction, 0);
    super.update(dt);
  }
}
