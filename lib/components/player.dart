// ignore_for_file: annotate_overrides

import 'dart:async';

import 'package:elemental_project/components/collision_block.dart';
import 'package:elemental_project/components/player_hitbox.dart';
import 'package:elemental_project/components/utils.dart';
import 'package:elemental_project/elemental_project.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

//to actually use the animation, use enum whihc is the player state
enum PlayerState { idle, running, jumping, falling }

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

//variable for step time so it can be changed if need be
  final double stepTime = 0.05;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;

  final double _gravity = 9.8;
  final double _jumpForce = 260;
  //constant velocity
  final double _terminalVelocity = 300;
  //move speed, velocity and direction
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;
  List<CollisionBlock> collisionBlocks = [];
  PlayerHitbox hitbox = PlayerHitbox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );

//calling upon our onload
  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();
    //debugMode = true;
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));
    //method will be called by onLoad
    return super.onLoad();
  }

  //update function, checking each method chronologically
  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _checkHorizontalCollisions();
    _applyGravity(dt);
    _checkVerticalCollisions();
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

    hasJumped = keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimation() {
    //these call upon the method below
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);

    //list of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
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

    //check if Falling set to falling
    if (velocity.y > 0) playerState = PlayerState.falling;

    //check if Jumping, set to jumping
    if (velocity.y < 0) playerState = PlayerState.jumping;

    current = playerState;
  }

//every frame update
  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

//jumping is subtracting from the velocity (going upwards is against gravity)
  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    //gravity grows therefor += so that we take the previous and add it on
    velocity.y += _gravity;
    //avatar can't go further up (-_jumpForce) and can't go faster down than terminal velocity
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }
}
