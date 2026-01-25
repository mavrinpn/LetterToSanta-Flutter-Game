import 'dart:collection';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:letter_to_santa/game/game.dart';

class ForestForeground extends PositionComponent with HasGameReference<LetterToSantaGame> {
  static final blockSize = Vector2(1536/2, 1024/2);
  late final Sprite groundBlock;
  late final Queue<SpriteComponent> ground;
  @override
  void onLoad() {
    super.onLoad();
    groundBlock = Sprite(game.images.fromCache('rails.webp'));
    ground = Queue();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final newBlocks = _generateBlocks();
    ground.addAll(newBlocks);
    addAll(newBlocks);
    y = size.y - blockSize.y;
  }

  List<SpriteComponent> _generateBlocks() {
    final number = 1 + (game.size.x / blockSize.x).ceil() - ground.length;
    final lastBlock = ground.lastOrNull;
    final lastX = lastBlock == null ? 0 : lastBlock.x + lastBlock.width;
    return List.generate(
      max(number, 0),
      (i) => SpriteComponent(
        sprite: groundBlock,
        size: blockSize,
        position: Vector2(lastX + blockSize.x * i, y),
        priority: -5,
      ),
      growable: false,
    );
  }
}
