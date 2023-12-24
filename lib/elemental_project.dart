import 'dart:async';

import 'package:elemental_project/earth_levels/earth.dart';
import 'package:flame/game.dart';

class ElementalProject extends FlameGame {
  @override
  FutureOr<void> onLoad() {
    add(Earth1());
    return super.onLoad();
  }
}
