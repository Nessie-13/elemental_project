import 'dart:async';

import 'package:elemental_project/components/player.dart';
import 'package:elemental_project/elemental_project.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Checkpoint extends SpriteAnimationComponent
    with HasGameRef<ElementalProject>, CollisionCallbacks {
  Checkpoint({
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  bool reachedChechpoint = false;

  @override
  FutureOr<void> onLoad() {
    //debugMode = true;
    add(RectangleHitbox(
      position: Vector2(18, 56),
      size: Vector2(12, 8),
      //in case items are overlapping, make them passive so they don't interact
      //unless it is the avatar
      collisionType: CollisionType.passive,
    ));
    animation = SpriteAnimation.fromFrameData(
      game.images
          .fromCache('Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1,
        textureSize: Vector2.all(64),
      ),
    );
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !reachedChechpoint) _reachedCheckpoint();
    super.onCollision(intersectionPoints, other);
  }

  void _reachedCheckpoint() {
    reachedChechpoint = true;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'),
      SpriteAnimationData.sequenced(
        amount: 26,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
        loop: false,
      ),
    );
    const flagDuration = Duration(milliseconds: 1300);
    Future.delayed(flagDuration, () {
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache(
            'Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png'),
        SpriteAnimationData.sequenced(
          amount: 10,
          stepTime: 0.05,
          textureSize: Vector2.all(64),
        ),
      );
    });
  }
}