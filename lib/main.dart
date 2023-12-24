import 'package:elemental_project/elemental_project.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  ElementalProject game = ElementalProject();
  runApp(
    GameWidget(game: kDebugMode ? ElementalProject() : game),
  );
}
