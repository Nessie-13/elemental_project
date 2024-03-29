import 'dart:async';

import 'package:elemental_project/components/custom_hitbox.dart';
import 'package:elemental_project/elemental_project.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class Coins extends SpriteAnimationComponent
    with HasGameRef<ElementalProject>, CollisionCallbacks {
  final String coins;
  Coins({
    this.coins = 'Coins',
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  //hitbox for coins, reducing the width and height around them,
  //making the hitbox closer to the coin
  final double stepTime = 0.05;
  final hitbox = CustomHitbox(
    offsetX: 3,
    offsetY: 0,
    width: 10,
    height: 16,
  );
  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    //debugMode = true;

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Coins/GoldCoinSpinning.png'),
      SpriteAnimationData.sequenced(
        amount: 24,
        stepTime: stepTime,
        textureSize: Vector2.all(8),
      ),
    );
    return super.onLoad();
  }

  void collidedWithPlayer() async {
    if (!collected) {
      collected = true;
      if (game.playSounds) FlameAudio.play('pickupCoin.wav', volume: game.soundVolume);
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Coins/Collected.png'),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
          loop: false,
        ),
      );

      await animationTicker?.completed;
      removeFromParent();
    }
  }
}
