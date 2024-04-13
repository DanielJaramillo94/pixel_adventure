import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  Player player = Player(character: 'Mask Dude');
  late JoystickComponent joystick;
  bool showJoystick = false;

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    final world = Level(
      levelName: 'Level-01',
      player: player,
    );

    camera = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    )..priority = 0;
    camera.viewfinder.anchor = Anchor.topLeft;

    addAll([camera, world]);
    if (showJoystick) {
      addJoystick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 1,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.upLeft:
      case JoystickDirection.left:
      case JoystickDirection.downLeft:
        // player.direction = PlayerDirection.left;
        break;
      case JoystickDirection.upRight:
      case JoystickDirection.right:
      case JoystickDirection.downRight:
        // player.direction = PlayerDirection.right;
        break;
      default:
        // player.direction = PlayerDirection.none;
        break;
    }
  }
}
