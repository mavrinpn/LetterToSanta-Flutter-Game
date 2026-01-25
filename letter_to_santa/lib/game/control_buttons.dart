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
  static const double buttonSize = 80.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 100;

    // Кнопка влево (стрелка влево)
    leftButton = HoldButton(
      size: Vector2.all(buttonSize),
      imageName: 'arrow_left.png',
      onHoldStart: () => game.startMovingForward(),
      onHoldEnd: () => game.stopMoving(),
    );

    // Кнопка вправо (стрелка вправо)
    rightButton = HoldButton(
      size: Vector2.all(buttonSize),
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

    // Размещаем кнопки в нижней части экрана
    final padding = 30.0;
    final spacing = 30.0;

    leftButton.position = Vector2(padding + buttonSize / 2, size.y - padding - buttonSize / 2);

    rightButton.position = Vector2(padding + buttonSize + spacing + buttonSize / 2, size.y - padding - buttonSize / 2);
  }
}
