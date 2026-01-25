import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letter_to_santa/game/index.dart';

class LetterToSantaGame extends FlameGame with KeyboardEvents {
  final ForestBackground forestBackground = ForestBackground();
  final ForestForeground forestForeground = ForestForeground();
  final Train train = Train();
  final ControlButtons controlButtons = ControlButtons();

  double currentSpeed = 0;
  bool isMovingForward = false;
  bool isMovingBackward = false;

  static const double maxSpeed = 300.0; // Максимальная скорость движения влево
  static const double minSpeed = -200.0; // Максимальная скорость движения вправо (назад)
  static const double acceleration = 500.0; // Ускорение

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await images.loadAllImages();
    add(forestBackground);
    add(forestForeground);
    add(train);
    add(controlButtons);
  }

  void startMovingForward() {
    isMovingForward = true;
    isMovingBackward = false;
  }

  void startMovingBackward() {
    isMovingBackward = true;
    isMovingForward = false;
  }

  void stopMoving() {
    isMovingForward = false;
    isMovingBackward = false;
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Проверяем нажатие стрелок
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        startMovingForward(); // Стрелка влево - движение вперед
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        startMovingBackward(); // Стрелка вправо - движение назад
        return KeyEventResult.handled;
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft || event.logicalKey == LogicalKeyboardKey.arrowRight) {
        stopMoving(); // Отпустили стрелку - останавливаемся
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Ускорение или замедление в зависимости от нажатых кнопок
    if (isMovingForward) {
      // Плавное ускорение вперед
      currentSpeed += acceleration * dt;
      if (currentSpeed > maxSpeed) currentSpeed = maxSpeed;
    } else if (isMovingBackward) {
      // Плавное ускорение назад
      currentSpeed -= acceleration * dt;
      if (currentSpeed < minSpeed) currentSpeed = minSpeed;
    } else {
      // Плавное замедление когда кнопки не нажаты
      if (currentSpeed > 0) {
        currentSpeed -= acceleration * dt;
        if (currentSpeed < 0) currentSpeed = 0;
      } else if (currentSpeed < 0) {
        currentSpeed += acceleration * dt;
        if (currentSpeed > 0) currentSpeed = 0;
      }
    }
  }
}
