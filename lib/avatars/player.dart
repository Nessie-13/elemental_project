// ignore_for_file: annotate_overrides

import 'dart:async';

import 'package:elemental_project/elemental_project.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

//to actually use the animation, use enum whihc is the player state
enum PlayerState { idle, running }

enum PlayerDirection { left, right, none }

//using a sprite animation group component to allow the avatar to move in all directions and even be idle
class Player extends SpriteAnimationGroupComponent
//adding keyboard controls
    with
        HasGameRef<ElementalProject>,
        KeyboardHandler {
  String character;
  //default avatar if nothing is passed through
  Player({position, this.character = 'Ninja Frog',
  }) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

//variable for step time so it can be changed if need be
  final double stepTime = 0.05;

//move speed, velocity and direction
  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
//boolean to check whether the avatar is facing right
  bool isFacingRight = true;

//calling upon our onload
  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();
    //underscore means that it is a private method
    //method allows for code to be kept neatly without having to add everything to the onLoad event
    //method will be called by onLoad
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isLRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (isLeftKeyPressed && isLRightKeyPressed) {
      playerDirection = PlayerDirection.none;
    } else if (isLeftKeyPressed) {
      playerDirection = PlayerDirection.left;
    } else if (isLRightKeyPressed) {
      playerDirection = PlayerDirection.right;
    } else {
      playerDirection = PlayerDirection.none;
    }

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

//every frame update
  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
//if statement  turning direction of avatar left
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.running;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        //if statement turning direction of avatar right
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.running;
        dirX += moveSpeed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
      default:
    }

//dt makes sure that the avatar is moving at 100 move speed at all times
    velocity = Vector2(dirX, 0.0);
    position += velocity * dt;
  }
}
