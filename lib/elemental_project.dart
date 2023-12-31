import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:elemental_project/earth_levels/earth.dart';

class ElementalProject extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late final CameraComponent cam;
  @override
  // ignore: annotate_overrides
  final world = Earth1();

  @override
  FutureOr<void> onLoad() {
    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);

    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    return super.onLoad();
  }
}
