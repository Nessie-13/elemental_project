import 'dart:async';

import 'package:elemental_project/components/checkpoint.dart';
import 'package:elemental_project/components/coins.dart';
import 'package:elemental_project/components/collision_block.dart';
import 'package:elemental_project/components/player.dart';
import 'package:elemental_project/components/saw.dart';
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

    _spawningObjects();
    _addCollisions();

    return super.onLoad();
    //super refers to whatever we are extending
  }

//by using methods, code looks more clean
//can be hidden using arrows
  void _spawningObjects() {
    //spawnpoint layer:
    //point at which the avatar will appear
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    //if statement to check for a null, if null then run
    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.scale.x = 1;
            add(player);
            break;
          case 'Coins':
            final coins = Coins(
              coins: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(coins);
            break;
          case 'Saw':
            //grabbing the values of isVertical, offNeg and offPos:
            final isVertical = spawnPoint.properties.getValue('isVertical');
            final offNeg = spawnPoint.properties.getValue('offNeg');
            final offPos = spawnPoint.properties.getValue('offPos');

            final saw = Saw(
              //passing in isVertical, offNeg, and offPos:
              isVertical: isVertical,
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(saw);
            break;
          case 'Checkpoint':
            final checkpoint = Checkpoint(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(checkpoint);
            break;
          default:
        }
      }
    }
  }

  void _addCollisions() {
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
  }
}
