import 'package:flame/components.dart';

//super is taking the passed position and size to what the class is extending (PositionComponent)
class CollisionBlock extends PositionComponent {
  //boolean to check for platform
  bool isPlatform;
  CollisionBlock({
    position,
    size,
    this.isPlatform = false,
  }) : super(
          position: position,
          size: size,
        ) {
    //you can see all collisions
    //debugMode = true;
  }
}
