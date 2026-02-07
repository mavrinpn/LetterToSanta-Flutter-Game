import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:letter_to_santa/game/game.dart';

class ForestBackground extends ParallaxComponent<LetterToSantaGame> {
  /// Скорость самого дальнего слоя относительно скорости земли.
  /// 0.1 означает, что cloud-bg движется в 10 раз медленнее земли.
  static const double _baseSpeedFraction = 0.1;

  /// Множитель скорости между соседними слоями (каждый ближний слой быстрее).
  ///
  /// Итоговые скорости слоёв (доля от скорости земли):
  ///   cloud-bg:  0.10x   cloud-1: 0.14x   cloud-2: 0.20x
  ///   cloud-3:   0.27x   cloud-4: 0.38x
  ///   forest-bg: 0.54x   forest-fg: 0.75x
  static const double _layerSpeedMultiplier = 1.4;

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
