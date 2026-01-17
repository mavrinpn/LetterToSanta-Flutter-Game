import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/train.dart';
import 'components/parallax_background.dart';
import 'components/control_buttons.dart';

class TrainGame extends FlameGame with HasCollisionDetection {
  late Train train;
  late ParallaxBackgroundComponent parallaxBackground;
  late ControlButtons controlButtons;
  
  // World boundaries
  final double worldWidth = 5000;
  final double worldStartX = 3750; // Start from right side (3/4 of world width)
  
  // Camera settings
  final double cameraThreshold = 0.25; // 1/4 of screen width
  double cameraOffsetX = 0;

  @override
  Color backgroundColor() => const Color(0xFF87CEEB); // Sky blue

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add parallax background
    parallaxBackground = ParallaxBackgroundComponent(
      worldWidth: worldWidth,
    );
    await add(parallaxBackground);
    
    // Initialize parallax with starting position
    parallaxBackground.updateParallax(worldStartX);

    // Add train - start at worldStartX in world coordinates
    train = Train(
      position: Vector2(size.x / 2, size.y - 150), // Screen position
      worldWidth: worldWidth,
    );
    train.worldPosition = worldStartX; // Set initial world position
    await add(train);

    // Add control buttons
    controlButtons = ControlButtons(
      onLeftPressed: () => train.moveLeft(),
      onLeftReleased: () => train.stopLeft(),
      onRightPressed: () => train.moveRight(),
      onRightReleased: () => train.stopRight(),
    );
    await add(controlButtons);
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateCamera(dt);
  }

  void updateCamera(double dt) {
    // Calculate train's screen position based on world position
    final threshold = size.x * cameraThreshold;
    final cameraX = (train.worldPosition - size.x / 2).clamp(0.0, worldWidth - size.x);
    
    // Train's screen position is relative to camera
    final trainScreenX = train.worldPosition - cameraX;
    
    // Clamp train's screen position to stay within threshold boundaries
    train.position.x = trainScreenX.clamp(threshold, size.x - threshold);
    
    // If train is at the start or end of the world, it can be centered
    if (cameraX <= 0) {
      // At the start of the world
      train.position.x = train.worldPosition;
    } else if (cameraX >= worldWidth - size.x) {
      // At the end of the world
      train.position.x = train.worldPosition - (worldWidth - size.x);
    }

    // Update parallax based on camera position
    parallaxBackground.updateParallax(cameraX);
  }
}
