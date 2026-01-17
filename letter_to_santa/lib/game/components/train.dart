import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Train extends PositionComponent {
  Train({required Vector2 position, required this.worldWidth})
    : super(position: position, size: Vector2(120, 80), anchor: Anchor.center);

  final double worldWidth;

  // Physics properties
  Vector2 velocity = Vector2.zero();
  final double maxSpeed = 300.0;
  final double acceleration = 100.0; // Slow acceleration like a real train
  final double deceleration = 200.0; // Faster braking

  // World position tracking
  double worldPosition = 0;

  // Movement state
  bool movingLeft = false;
  bool movingRight = false;

  @override
  void update(double dt) {
    super.update(dt);

    // Apply acceleration based on input
    if (movingLeft) {
      velocity.x -= acceleration * dt;
    } else if (movingRight) {
      velocity.x += acceleration * dt;
    } else {
      // Apply deceleration when no input
      if (velocity.x > 0) {
        velocity.x = (velocity.x - deceleration * dt).clamp(0, maxSpeed);
      } else if (velocity.x < 0) {
        velocity.x = (velocity.x + deceleration * dt).clamp(-maxSpeed, 0);
      }
    }

    // Clamp velocity to max speed
    velocity.x = velocity.x.clamp(-maxSpeed, maxSpeed);

    // Update world position
    worldPosition += velocity.x * dt;

    // Keep world position within bounds
    worldPosition = worldPosition.clamp(0, worldWidth);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw train body (simple representation)
    final trainPaint = Paint()
      ..color = const Color(0xFFD32F2F)
      ..style = PaintingStyle.fill;

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(size.x / 2, size.y / 2), width: size.x, height: size.y * 0.6),
      const Radius.circular(8),
    );
    canvas.drawRRect(bodyRect, trainPaint);

    // Draw cabin
    final cabinPaint = Paint()
      ..color = const Color(0xFF1976D2)
      ..style = PaintingStyle.fill;

    final cabinRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.x * 0.6, size.y * 0.2, size.x * 0.3, size.y * 0.4),
      const Radius.circular(4),
    );
    canvas.drawRRect(cabinRect, cabinPaint);

    // Draw windows
    final windowPaint = Paint()
      ..color = const Color(0xFFFFEB3B)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(size.x * 0.65, size.y * 0.25, size.x * 0.08, size.y * 0.15), windowPaint);
    canvas.drawRect(Rect.fromLTWH(size.x * 0.78, size.y * 0.25, size.x * 0.08, size.y * 0.15), windowPaint);

    // Draw wheels
    final wheelPaint = Paint()
      ..color = const Color(0xFF424242)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.x * 0.25, size.y * 0.85), size.y * 0.15, wheelPaint);
    canvas.drawCircle(Offset(size.x * 0.5, size.y * 0.85), size.y * 0.15, wheelPaint);
    canvas.drawCircle(Offset(size.x * 0.75, size.y * 0.85), size.y * 0.15, wheelPaint);

    // Draw wheel centers
    final wheelCenterPaint = Paint()
      ..color = const Color(0xFF757575)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.x * 0.25, size.y * 0.85), size.y * 0.08, wheelCenterPaint);
    canvas.drawCircle(Offset(size.x * 0.5, size.y * 0.85), size.y * 0.08, wheelCenterPaint);
    canvas.drawCircle(Offset(size.x * 0.75, size.y * 0.85), size.y * 0.08, wheelCenterPaint);

    // Draw chimney
    final chimneyPaint = Paint()
      ..color = const Color(0xFF424242)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(size.x * 0.15, size.y * 0.15, size.x * 0.12, size.y * 0.3), chimneyPaint);
  }

  void moveLeft() {
    movingLeft = true;
    movingRight = false;
  }

  void moveRight() {
    movingRight = true;
    movingLeft = false;
  }

  void stopLeft() {
    movingLeft = false;
  }

  void stopRight() {
    movingRight = false;
  }
}
