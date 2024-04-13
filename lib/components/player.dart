import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  Player({
    Vector2? position,
    this.character = 'Ninja Frog',
  }) : super(position: position);

  final String character;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05;

  double horizontalMovement = 0;
  double speed = 100;
  Vector2 playerPosition = Vector2.zero();

  @override
  Future<void> onLoad() async {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updateMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: 11,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (playerPosition.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (playerPosition.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    current = playerState;
  }

  void _updateMovement(double dt) {
    playerPosition.x = horizontalMovement * speed;
    position.x += playerPosition.x * dt;
  }
}
