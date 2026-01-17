import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class ParallaxBackgroundComponent extends Component {
  ParallaxBackgroundComponent({
    required this.worldWidth,
  });

  final double worldWidth;
  
  // Parallax layers with different speeds
  final List<ParallaxLayer> layers = [];
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Create multiple layers for parallax effect
    // Each layer moves at a different speed relative to camera
    layers.addAll([
      ParallaxLayer(
        color: const Color(0xFF4A148C),
        speed: 0.1,
        yOffset: 0,
        height: 150,
        type: LayerType.mountains,
      ),
      ParallaxLayer(
        color: const Color(0xFF6A1B9A),
        speed: 0.2,
        yOffset: 100,
        height: 200,
        type: LayerType.hills,
      ),
      ParallaxLayer(
        color: const Color(0xFF8E24AA),
        speed: 0.35,
        yOffset: 200,
        height: 180,
        type: LayerType.forest,
      ),
      ParallaxLayer(
        color: const Color(0xFF2E7D32),
        speed: 0.5,
        yOffset: 300,
        height: 100,
        type: LayerType.grass,
      ),
      ParallaxLayer(
        color: const Color(0xFF1B5E20),
        speed: 0.7,
        yOffset: 350,
        height: 80,
        type: LayerType.ground,
      ),
    ]);
  }

  void updateParallax(double cameraX) {
    for (final layer in layers) {
      layer.offset = -cameraX * layer.speed;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    if (parent == null) return;
    final game = findParent<FlameGame>();
    if (game == null) return;

    for (final layer in layers) {
      layer.render(canvas, game.size);
    }
  }
}

enum LayerType {
  mountains,
  hills,
  forest,
  grass,
  ground,
}

class ParallaxLayer {
  ParallaxLayer({
    required this.color,
    required this.speed,
    required this.yOffset,
    required this.height,
    required this.type,
  });

  final Color color;
  final double speed;
  final double yOffset;
  final double height;
  final LayerType type;
  double offset = 0;

  void render(Canvas canvas, Vector2 screenSize) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    
    switch (type) {
      case LayerType.mountains:
        _drawMountains(path, screenSize, offset);
      case LayerType.hills:
        _drawHills(path, screenSize, offset);
      case LayerType.forest:
        _drawForest(canvas, screenSize, offset);
        return;
      case LayerType.grass:
        _drawGrass(path, screenSize, offset);
      case LayerType.ground:
        _drawGround(path, screenSize);
    }

    canvas.drawPath(path, paint);
  }

  void _drawMountains(Path path, Vector2 screenSize, double offset) {
    path.moveTo(-200 + offset, screenSize.y);
    
    for (var i = -1; i < 4; i++) {
      final x = i * 400.0 + offset;
      path.lineTo(x, screenSize.y);
      path.lineTo(x + 200, yOffset);
      path.lineTo(x + 400, screenSize.y);
    }
    
    path.lineTo(screenSize.x + 200, screenSize.y);
    path.close();
  }

  void _drawHills(Path path, Vector2 screenSize, double offset) {
    path.moveTo(-200 + offset, screenSize.y);
    
    for (var i = -1; i < 5; i++) {
      final x = i * 300.0 + offset;
      path.quadraticBezierTo(
        x + 75, yOffset,
        x + 150, yOffset + 50,
      );
      path.quadraticBezierTo(
        x + 225, yOffset + 100,
        x + 300, yOffset + 120,
      );
    }
    
    path.lineTo(screenSize.x + 200, screenSize.y);
    path.lineTo(-200 + offset, screenSize.y);
    path.close();
  }

  void _drawForest(Canvas canvas, Vector2 screenSize, double offset) {
    final treePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw simplified trees
    for (var i = -1; i < 15; i++) {
      final x = i * 80.0 + offset % 80;
      final treeHeight = 60.0 + (i % 3) * 20.0;
      
      // Tree trunk
      canvas.drawRect(
        Rect.fromLTWH(x + 35, yOffset + height - treeHeight, 10, treeHeight * 0.4),
        Paint()..color = const Color(0xFF4E342E),
      );
      
      // Tree foliage (triangle)
      final path = Path()
        ..moveTo(x + 40, yOffset + height - treeHeight)
        ..lineTo(x + 10, yOffset + height - treeHeight * 0.4)
        ..lineTo(x + 70, yOffset + height - treeHeight * 0.4)
        ..close();
      
      canvas.drawPath(path, treePaint);
    }
  }

  void _drawGrass(Path path, Vector2 screenSize, double offset) {
    path.moveTo(offset - 100, yOffset + height);
    
    // Create wavy grass pattern
    for (var i = 0; i < 20; i++) {
      final x = i * 100.0 + offset;
      path.quadraticBezierTo(
        x + 25, yOffset + height - 10,
        x + 50, yOffset + height,
      );
      path.quadraticBezierTo(
        x + 75, yOffset + height + 5,
        x + 100, yOffset + height,
      );
    }
    
    path.lineTo(screenSize.x + 100, screenSize.y);
    path.lineTo(offset - 100, screenSize.y);
    path.close();
  }

  void _drawGround(Path path, Vector2 screenSize) {
    // Ground with railway
    path.moveTo(0, yOffset);
    path.lineTo(screenSize.x, yOffset);
    path.lineTo(screenSize.x, screenSize.y);
    path.lineTo(0, screenSize.y);
    path.close();
  }
}
