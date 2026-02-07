import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:letter_to_santa/game/game.dart';

// Кастомная кнопка-картинка с поддержкой удержания
class HoldButton extends SpriteComponent with TapCallbacks, HasGameReference<LetterToSantaGame> {
  final VoidCallback onHoldStart;
  final VoidCallback onHoldEnd;
  final String imageName;

  HoldButton({required this.onHoldStart, required this.onHoldEnd, required this.imageName, required super.size})
    : super(anchor: Anchor.center);

  bool isPressed = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = Sprite(game.images.fromCache(imageName));
  }

  @override
  void onTapDown(TapDownEvent event) {
    isPressed = true;
    opacity = 0.7; // Затемняем при нажатии
    onHoldStart();
  }

  @override
  void onTapUp(TapUpEvent event) {
    isPressed = false;
    opacity = 1.0; // Возвращаем нормальную прозрачность
    onHoldEnd();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    isPressed = false;
    opacity = 1.0;
    onHoldEnd();
  }
}

class ControlButtons extends PositionComponent with HasGameReference<LetterToSantaGame> {
  late final HoldButton leftButton;
  late final HoldButton rightButton;

  /// Порог короткой стороны экрана для разделения телефон/планшет
  static const double _tabletThreshold = 600.0;

  // Параметры для планшета (iPad)
  static const double _tabletButtonSize = 80.0;
  static const double _tabletPadding = 30.0;

  // Параметры для телефона (iPhone / смартфон)
  static const double _phoneButtonSize = 60.0;
  static const double _phonePadding = 20.0;

  bool get _isTablet => game.size.y >= _tabletThreshold;
  double get _buttonSize => _isTablet ? _tabletButtonSize : _phoneButtonSize;
  double get _padding => _isTablet ? _tabletPadding : _phonePadding;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 100;

    // Кнопка влево (стрелка влево)
    leftButton = HoldButton(
      size: Vector2.all(_tabletButtonSize),
      imageName: 'arrow_left.png',
      onHoldStart: () => game.startMovingForward(),
      onHoldEnd: () => game.stopMoving(),
    );

    // Кнопка вправо (стрелка вправо)
    rightButton = HoldButton(
      size: Vector2.all(_tabletButtonSize),
      imageName: 'arrow_right.png',
      onHoldStart: () => game.startMovingBackward(),
      onHoldEnd: () => game.stopMoving(),
    );

    add(leftButton);
    add(rightButton);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    final btnSize = _buttonSize;
    final padding = _padding;

    // Обновляем размер кнопок под текущее устройство
    leftButton.size = Vector2.all(btnSize);
    rightButton.size = Vector2.all(btnSize);

    // Размещаем кнопки по разным сторонам экрана для удобного управления двумя руками
    final bottomY = size.y - padding - btnSize / 2;
    leftButton.position = Vector2(padding + btnSize / 2, bottomY);
    rightButton.position = Vector2(size.x - padding - btnSize / 2, bottomY);
  }
}
