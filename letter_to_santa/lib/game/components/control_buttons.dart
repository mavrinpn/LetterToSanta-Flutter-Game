import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class ControlButtons extends PositionComponent with HasGameReference<FlameGame> {
  ControlButtons({
    required this.onLeftPressed,
    required this.onLeftReleased,
    required this.onRightPressed,
    required this.onRightReleased,
  });

  final VoidCallback onLeftPressed;
  final VoidCallback onLeftReleased;
  final VoidCallback onRightPressed;
  final VoidCallback onRightReleased;

  late GameButton leftButton;
  late GameButton rightButton;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final buttonSize = Vector2(80, 80);
    final padding = 40.0;

    // Left button
    leftButton = GameButton(
      size: buttonSize,
      position: Vector2(padding, game.size.y - buttonSize.y - padding),
      onPressed: onLeftPressed,
      onReleased: onLeftReleased,
      direction: ArrowDirection.left,
    );

    // Right button
    rightButton = GameButton(
      size: buttonSize,
      position: Vector2(
        padding + buttonSize.x + 20,
        game.size.y - buttonSize.y - padding,
      ),
      onPressed: onRightPressed,
      onReleased: onRightReleased,
      direction: ArrowDirection.right,
    );

    await add(leftButton);
    await add(rightButton);
  }
}

class GameButton extends PositionComponent with TapCallbacks {
  GameButton({
    required Vector2 size,
    required Vector2 position,
    required this.onPressed,
    required this.onReleased,
    required this.direction,
  }) : super(
          size: size,
          position: position,
          anchor: Anchor.topLeft,
        );

  final VoidCallback onPressed;
  final VoidCallback onReleased;
  final ArrowDirection direction;
  bool isPressed = false;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw button circle
    final paint = Paint()
      ..color = isPressed ? Colors.blue.withAlpha(200) : Colors.white.withAlpha(180)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      paint,
    );

    // Draw arrow
    final arrowPaint = Paint()
      ..color = Colors.black.withAlpha(200)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final center = Offset(size.x / 2, size.y / 2);
    final arrowSize = size.x * 0.3;

    if (direction == ArrowDirection.left) {
      // Left arrow
      path.moveTo(center.dx + arrowSize * 0.5, center.dy - arrowSize * 0.5);
      path.lineTo(center.dx - arrowSize * 0.5, center.dy);
      path.lineTo(center.dx + arrowSize * 0.5, center.dy + arrowSize * 0.5);
    } else {
      // Right arrow
      path.moveTo(center.dx - arrowSize * 0.5, center.dy - arrowSize * 0.5);
      path.lineTo(center.dx + arrowSize * 0.5, center.dy);
      path.lineTo(center.dx - arrowSize * 0.5, center.dy + arrowSize * 0.5);
    }

    canvas.drawPath(path, arrowPaint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    isPressed = true;
    onPressed();
  }

  @override
  void onTapUp(TapUpEvent event) {
    isPressed = false;
    onReleased();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    isPressed = false;
    onReleased();
  }
}

enum ArrowDirection { left, right }
