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
  final MovementController movement = MovementController();

  /// Текущая скорость мира (делегируется к MovementController)
  double get currentSpeed => movement.currentSpeed;

  /// Удобные методы-делегаты для управления движением
  void startMovingForward() => movement.startMovingForward();
  void startMovingBackward() => movement.startMovingBackward();
  void stopMoving() => movement.stopMoving();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await images.loadAllImages();
    add(movement);
    add(forestBackground);
    add(forestForeground);
    add(train);
    add(controlButtons);
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
}
