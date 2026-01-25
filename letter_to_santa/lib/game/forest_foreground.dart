import 'dart:collection';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:letter_to_santa/game/game.dart';

class ForestForeground extends PositionComponent with HasGameReference<LetterToSantaGame> {
  static final blockSize = Vector2(1536 / 2, 272 / 2);
  late final Sprite groundBlock;
  // late final Sprite railsBlock;
  late final Queue<SpriteComponent> groundLayer;
  // late final Queue<SpriteComponent> rails;

  @override
  void onLoad() {
    super.onLoad();
    groundBlock = Sprite(game.images.fromCache('ground.png'));
    // railsBlock = Sprite(game.images.fromCache('rails.webp'));
    groundLayer = Queue();
    // rails = Queue();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    // Генерируем блоки земли
    final newGroundBlocks = _generateBlocks(groundBlock, -6);
    groundLayer.addAll(newGroundBlocks);
    addAll(newGroundBlocks);

    // Генерируем блоки рельсов
    // final newRailsBlocks = _generateBlocks(railsBlock, -5);
    // rails.addAll(newRailsBlocks);
    // addAll(newRailsBlocks);

    y = size.y - blockSize.y;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Обновляем слой земли
    _updateLayer(groundLayer, groundBlock, -6, dt);

    // Обновляем слой рельсов
    // _updateLayer(rails, railsBlock, -5, dt);
  }

  void _updateLayer(Queue<SpriteComponent> layer, Sprite sprite, int priority, double dt) {
    // Двигаем все блоки в зависимости от скорости поезда
    // Положительная скорость - мир движется вправо (поезд "едет" влево)
    for (final block in layer) {
      block.x += game.currentSpeed * dt;
    }

    // Удаляем блоки, которые ушли за правый край экрана
    while (layer.isNotEmpty && layer.first.x > game.size.x) {
      final block = layer.removeFirst();
      remove(block);
    }

    // Удаляем блоки, которые ушли за левый край экрана
    while (layer.isNotEmpty && layer.last.x + blockSize.x < 0) {
      final block = layer.removeLast();
      remove(block);
    }

    // Добавляем новые блоки слева, если нужно
    if (layer.isNotEmpty && layer.last.x + blockSize.x > 0) {
      final newBlock = SpriteComponent(
        sprite: sprite,
        size: blockSize,
        position: Vector2(layer.last.x - blockSize.x, 0),
        priority: priority,
      );
      layer.addLast(newBlock);
      add(newBlock);
    }

    // Добавляем новые блоки справа, если нужно
    if (layer.isNotEmpty && layer.first.x < game.size.x) {
      final newBlock = SpriteComponent(
        sprite: sprite,
        size: blockSize,
        position: Vector2(layer.first.x + blockSize.x, 0),
        priority: priority,
      );
      layer.addFirst(newBlock);
      add(newBlock);
    }
  }

  List<SpriteComponent> _generateBlocks(Sprite sprite, int priority) {
    final number = 1 + (game.size.x / blockSize.x).ceil();
    return List.generate(
      max(number, 0),
      (i) =>
          SpriteComponent(sprite: sprite, size: blockSize, position: Vector2(blockSize.x * i, 0), priority: priority),
      growable: false,
    );
  }
}
