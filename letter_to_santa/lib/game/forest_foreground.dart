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

  late final Sprite groundBlock2;
  late final Sprite groundBlock3;
  late final Sprite groundBlock4;

  /// Индексы крайних блоков земли — для последовательности 10×g1, 1×g2, 1×g3, ∞×g4
  int _groundLeftmostIndex = 0;
  int _groundRightmostIndex = 0;

  @override
  void onLoad() {
    super.onLoad();
    groundBlock = Sprite(game.images.fromCache('ground_1.png'));
    groundBlock2 = Sprite(game.images.fromCache('ground_2.png'));
    groundBlock3 = Sprite(game.images.fromCache('ground_3.png'));
    groundBlock4 = Sprite(game.images.fromCache('ground_4.png'));
    railsBlock = Sprite(game.images.fromCache('rails.png'));
    groundLayer = Queue();
    railsLayer = Queue();
  }

  /// Вариант А: поезд едет справа налево, первыми встречаем ground_1 (10×), потом g2, g3, g4 ∞.
  /// Индекс 0 — справа (старт), растёт влево.
  Sprite _groundSpriteForIndex(int index) {
    if (index < 0) return groundBlock4; // правее старта — ground_4 ∞
    if (index < 10) return groundBlock; // 0–9: ground_1
    if (index == 10) return groundBlock2; // ground_2
    if (index == 11) return groundBlock3; // ground_3
    return groundBlock4; // 12+: ground_4 ∞
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

    // Генерируем блоки земли (внизу, y=0) — последовательность: 10×g1, 1×g2, 1×g3, ∞×g4
    // Индекс 0 справа (старт, ground_1), first=rightmost
    final (newGroundBlocks, leftIdx, rightIdx) = _generateGroundBlocks();
    groundLayer.addAll(newGroundBlocks.reversed);
    addAll(newGroundBlocks);
    _groundLeftmostIndex = leftIdx;
    _groundRightmostIndex = rightIdx;

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

  void _updateGroundLayer(double dt) {
    final blockSize = groundBlockSize;
    final basePosition = Vector2.zero();
    const priority = -6;

    for (final block in groundLayer) {
      block.x += game.currentSpeed * dt;
    }

    // Удаляем блоки справа (rightmost = index 0, ground_1)
    while (groundLayer.isNotEmpty && groundLayer.first.x > game.size.x) {
      final block = groundLayer.removeFirst();
      remove(block);
      _groundRightmostIndex++;
    }

    // Удаляем блоки слева (leftmost = высокий индекс, ground_4)
    while (groundLayer.isNotEmpty && groundLayer.last.x + blockSize.x < 0) {
      final block = groundLayer.removeLast();
      remove(block);
      _groundLeftmostIndex--;
    }

    // Добавляем блок слева — индекс растёт влево (g2, g3, g4)
    if (groundLayer.isNotEmpty && groundLayer.last.x + blockSize.x > 0) {
      final newIndex = _groundLeftmostIndex + 1;
      final newBlock = SpriteComponent(
        sprite: _groundSpriteForIndex(newIndex),
        size: blockSize,
        position: Vector2(groundLayer.last.x - blockSize.x, basePosition.y),
        priority: priority,
      );
      groundLayer.addLast(newBlock);
      add(newBlock);
      _groundLeftmostIndex = newIndex;
    }

    // Добавляем блок справа — индекс уменьшается (g4 ∞ правее старта)
    if (groundLayer.isNotEmpty && groundLayer.first.x < game.size.x) {
      final newIndex = _groundRightmostIndex - 1;
      final newBlock = SpriteComponent(
        sprite: _groundSpriteForIndex(newIndex),
        size: blockSize,
        position: Vector2(groundLayer.first.x + blockSize.x, basePosition.y),
        priority: priority,
      );
      groundLayer.addFirst(newBlock);
      add(newBlock);
      _groundRightmostIndex = newIndex;
    }
  }

  /// Возвращает (блоки, leftmostIndex, rightmostIndex).
  /// Индекс 0 — справа (старт, ground_1), растёт влево.
  (List<SpriteComponent>, int, int) _generateGroundBlocks() {
    final blockSize = groundBlockSize;
    final number = max(1 + (game.size.x / blockSize.x).ceil(), 0);
    final blocks = <SpriteComponent>[];
    for (var i = 0; i < number; i++) {
      // i=0 слева, i=N-1 справа; индекс 0 — справа (ground_1)
      final index = number - 1 - i;
      blocks.add(SpriteComponent(
        sprite: _groundSpriteForIndex(index),
        size: blockSize,
        position: Vector2(blockSize.x * i, 0),
        priority: -6,
      ));
    }
    // leftmost (i=0) = index N-1, rightmost (i=N-1) = index 0
    return (blocks, number - 1, 0);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Обновляем слой земли (с последовательностью ground_1..4)
    _updateGroundLayer(dt);

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
