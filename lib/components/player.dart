// ignore_for_file: annotate_overrides

import 'dart:async';

import 'package:elemental_project/components/collision_block.dart';
import 'package:elemental_project/components/utils.dart';
import 'package:elemental_project/elemental_project.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

//to actually use the animation, use enum whihc is the player state
enum PlayerState { idle, running }

//using a sprite animation group component to allow the avatar to move in all directions and even be idle
class Player extends SpriteAnimationGroupComponent
//adding keyboard controls
    with
        HasGameRef<ElementalProject>,
        KeyboardHandler {
  String character;
  //default avatar if nothing is passed through
  Player({
    position,
    this.character = 'Ninja Frog',
  }) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

//variable for step time so it can be changed if need be
  final double stepTime = 0.05;

//move speed, velocity and direction
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  List<CollisionBlock> collisionBlocks = [];

//calling upon our onload
  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();
    debugMode = true;

    //method will be called by onLoad
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _checkHorizontalCollisions();
    super.update(dt);
  }

  @override
  //starting point is 0
  //if press left we add -1
  //if press right add 1
  //if both are pressed, -1 + 1 = 0, so idle
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isLRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

//ternerary operatoor is like an if-statement on one line
//it says if isLeftKeyPressed is true add -1 and if false add 0
//this is what shortens down the if statements from before
    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isLRightKeyPressed ? 1 : 0;

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimation() {
    //these call upon the method below
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);

    //list of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    //set current animation
    current = PlayerState.idle;
  }

//private method so that repeated code doesn't have to be copied and pasted
  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        //number of pictures in image
        amount: amount,
        //50milliseconds or 20FPS
        stepTime: 0.05,
        //dimensions of avatar image
        textureSize: Vector2.all(32),
      ),
    );
  }

//update player state method
  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    //check if moving, set running
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    current = playerState;
  }

//every frame update
  void _updatePlayerMovement(double dt) {
//this multiplies movement with movespeed
//if -1, then negative movespeed
//if 1 then positive movespeed
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      //handle collisions
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - width;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + width;
          }
        }
      }
    }
  }
}
