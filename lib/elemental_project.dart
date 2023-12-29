import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:elemental_project/earth_levels/earth.dart';


class ElementalProject extends FlameGame {
  late final CameraComponent cam;

  final world = level();


  @override
  FutureOr<void> onLoad() {
    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    addAll([cam, world]);
    return super.onLoad();
  }
}
