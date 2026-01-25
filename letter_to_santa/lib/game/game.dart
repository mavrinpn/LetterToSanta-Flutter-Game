import 'package:flame/game.dart';
import 'package:letter_to_santa/game/index.dart';

class LetterToSantaGame extends FlameGame {
  final ForestBackground forestBackground = ForestBackground();
  final ForestForeground forestForeground = ForestForeground();
  final Train train = Train();

  double currentSpeed = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await images.loadAllImages();
    add(forestBackground);
    add(forestForeground);
    add(train);
  }
}
