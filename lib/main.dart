import 'package:elemental_project/elemental_project.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//Window, set to landscape 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

//using the await allows us to make sure that the game is loaded,
// set to landscape and then the joystick is loaded
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  ElementalProject game = ElementalProject();
  runApp(
    GameWidget(game: kDebugMode ? ElementalProject() : game),
  );
}
