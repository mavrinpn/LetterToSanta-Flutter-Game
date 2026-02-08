import 'dart:collection';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:letter_to_santa/game/game.dart';

class ForestForeground extends PositionComponent with HasGameReference<LetterToSantaGame> {
  /// Доля высоты экрана, которую занимает полоса земли
  static const double groundHeightFraction = 0.16;

  /// ground_1.png: 1536×221
  static const double _groundAspectRatio = 1536 / 221;

  /// rails.png: 1536×270 — рельсы выше земли, выступают над ней
  static const double _railsAspectRatio = 1536 / 270;
  static const double _railsToGroundHeightRatio = 270 / 221;

  late Vector2 groundBlockSize;
  late Vector2 railsBlockSize;
  late final Sprite groundBlock;
  late final Sprite railsBlock;
  late final Queue<SpriteComponent> groundLayer;
  late final Queue<SpriteComponent> railsLayer;

  @override
  void onLoad() {
    super.onLoad();
    groundBlock = Sprite(game.images.fromCache('ground_1.png'));
    railsBlock = Sprite(game.images.fromCache('rails.png'));
    groundLayer = Queue();
    railsLayer = Queue();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    // Размеры блоков пропорциональны высоте экрана
    final groundHeight = size.y * groundHeightFraction;
    groundBlockSize = Vector2(groundHeight * _groundAspectRatio, groundHeight);

    // Рельсы выше земли — выступают над ней
    final railsHeight = groundHeight * _railsToGroundHeightRatio;
    railsBlockSize = Vector2(railsHeight * _railsAspectRatio, railsHeight);

    // Очищаем старые блоки перед генерацией новых
    _clearLayer(groundLayer);
    _clearLayer(railsLayer);

    // Генерируем блоки земли (внизу, y=0)
    final newGroundBlocks = _generateBlocks(groundBlock, groundBlockSize, Vector2.zero(), -6);
    groundLayer.addAll(newGroundBlocks);
    addAll(newGroundBlocks);

    // Генерируем блоки рельсов — нижний край на уровне верха земли, выступают вверх
    final railsY = groundBlockSize.y - railsBlockSize.y;
    final newRailsBlocks = _generateBlocks(railsBlock, railsBlockSize, Vector2(0, railsY), -5);
    railsLayer.addAll(newRailsBlocks);
    addAll(newRailsBlocks);

    y = size.y - groundBlockSize.y;
  }

  void _clearLayer(Queue<SpriteComponent> layer) {
    for (final block in layer) {
      remove(block);
    }
    layer.clear();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Обновляем слой земли
    _updateLayer(groundLayer, groundBlock, groundBlockSize, Vector2.zero(), -6, dt);

    // Обновляем слой рельсов
    final railsY = groundBlockSize.y - railsBlockSize.y;
    _updateLayer(railsLayer, railsBlock, railsBlockSize, Vector2(0, railsY), -5, dt);
  }

  void _updateLayer(
    Queue<SpriteComponent> layer,
    Sprite sprite,
    Vector2 blockSize,
    Vector2 basePosition,
    int priority,
    double dt,
  ) {
    // Двигаем все блоки в зависимости от скорости поезда
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
        position: Vector2(layer.last.x - blockSize.x, basePosition.y),
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
        position: Vector2(layer.first.x + blockSize.x, basePosition.y),
        priority: priority,
      );
      layer.addFirst(newBlock);
      add(newBlock);
    }
  }

  List<SpriteComponent> _generateBlocks(Sprite sprite, Vector2 blockSize, Vector2 basePosition, int priority) {
    final number = 1 + (game.size.x / blockSize.x).ceil();
    return List.generate(
      max(number, 0),
      (i) => SpriteComponent(
        sprite: sprite,
        size: blockSize,
        position: Vector2(blockSize.x * i, basePosition.y),
        priority: priority,
      ),
      growable: false,
    );
  }
}
