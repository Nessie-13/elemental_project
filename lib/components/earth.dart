import 'dart:async';

import 'package:elemental_project/components/collision_block.dart';
import 'package:elemental_project/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Earth1 extends World {
  final String levelName;
  final Player player;
  Earth1({required this.levelName, required this.player});
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);
    //spawnpoint layer:
    //point at which the avatar will appear
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

//if statement to check for a null, if null then run
    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          default:
        }
      }
    }

    //collsions layer:
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    //if statement to search through each object, check if its a platform
    //if it is a platform, make the collision block, then add to list
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }

    player.collisionBlocks = collisionBlocks;
    return super.onLoad();
    //super refers to whatever we are extending
  }
}
