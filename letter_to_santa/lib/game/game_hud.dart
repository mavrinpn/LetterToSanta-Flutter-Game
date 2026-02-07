import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:letter_to_santa/game/game.dart';

/// HUD с информацией о скорости и пройденном расстоянии.
class GameHud extends PositionComponent with HasGameReference<LetterToSantaGame> {
  late final TextComponent _speedText;
  late final TextComponent _distanceText;

  /// Порог короткой стороны экрана для разделения телефон/планшет
  static const double _tabletThreshold = 600.0;

  // Параметры для планшета
  static const double _tabletFontSize = 36.0;
  static const double _tabletPadding = 20.0;

  // Параметры для телефона
  static const double _phoneFontSize = 30.0;
  static const double _phonePadding = 12.0;

  bool get _isTablet => game.size.y >= _tabletThreshold;
  double get _fontSize => _isTablet ? _tabletFontSize : _phoneFontSize;
  double get _padding => _isTablet ? _tabletPadding : _phonePadding;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 100;

    _speedText = TextComponent(
      text: '',
      anchor: Anchor.topLeft,
    );

    _distanceText = TextComponent(
      text: '',
      anchor: Anchor.topRight,
    );

    add(_speedText);
    add(_distanceText);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    final padding = _padding;
    final style = _buildTextStyle();

    _speedText
      ..textRenderer = TextPaint(style: style)
      ..position = Vector2(padding, padding);

    _distanceText
      ..textRenderer = TextPaint(style: style)
      ..position = Vector2(size.x - padding, padding);
  }

  @override
  void update(double dt) {
    super.update(dt);

    final speed = game.movement.speedKmh.round();
    _speedText.text = '$speed км/ч';

    final distance = game.movement.distanceMeters;
    if (distance >= 1000) {
      _distanceText.text = '${(distance / 1000).toStringAsFixed(1)} км';
    } else {
      _distanceText.text = '${distance.round()} м';
    }
  }

  TextStyle _buildTextStyle() {
    return TextStyle(
      fontSize: _fontSize,
      fontWeight: FontWeight.bold,
      color: const Color(0xFFFFFFFF),
      shadows: const [
        Shadow(offset: Offset(1, 1), blurRadius: 3, color: Color(0xAA000000)),
      ],
    );
  }
}
