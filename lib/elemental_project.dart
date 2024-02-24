import 'dart:async';

import 'package:elemental_project/components/jump_button.dart';
import 'package:elemental_project/components/player.dart';
import 'package:elemental_project/components/csv_loader.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:elemental_project/components/earth.dart';
import 'package:flame/input.dart';
import 'package:flutter/painting.dart';

//have the ability for components to handle the keyboard
class ElementalProject extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  Player player = Player(character: 'Mask Dude');
  late JoystickComponent joystick;
  bool showControls = false;
  bool playSounds = true;
  double soundVolume = 1.0;
  List<String> levelNames = [
    'level-e01',
    'level-e02',
    'level-e03',
    'level-e04',
    'level-w01',
    'level-w02',
    'level-w03',
    'level-w04',
    'level-f01',
    'level-f02',
    'level-f03',
    'level-f04',
    'level-a01',
    'level-a02',
    'level-a03',
    'level-a04',
  ];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    //Load all images into cache
    await images.loadAllImages();
    // ignore: unused_local_variable
    List questions = await loadCSV();

//passing our player into the level method

    _loadLevel();

    if (showControls) {
      addJoystick();
      add(JumpButton());
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }
    super.update(dt);
  }

  //creating/adding a joystick
  void addJoystick() {
    joystick = JoystickComponent(
      priority: 50,
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
      margin: const EdgeInsets.only(left: 20, bottom: 20),
    );

    add(joystick);
  }

//joystick method
  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;

      default:
        //idle
        player.horizontalMovement = 0;
        break;
    }
  }

  void loadNextLevel() {
    removeWhere((component) => component is Earth1);

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      //no more levels
      currentLevelIndex = 0;
      _loadLevel();
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      Earth1 world = Earth1(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      cam = CameraComponent.withFixedResolution(
        world: world,
        width: 640,
        height: 360,
      );
      cam.viewfinder.anchor = Anchor.topLeft;

      addAll([cam, world]);
    });
  }
}
