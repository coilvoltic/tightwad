import 'package:flutter/material.dart';

class Background
{
  Color light = Color.fromRGBO(231, 236, 239, 1);
  Color dark  = Color.fromRGBO(46, 50, 57, 1);

  Color get getLightColor => light;
  Color get getDarkColor  => dark;
}

class TileShadow
{
  Color light = Color.fromRGBO(167, 169, 175, 1);
  Color dark  = Color.fromRGBO(35, 38, 42, 1);

  Color get getLightColor => light;
  Color get getDarkColor  => dark;
}

class TileBrightness
{
  Color light = Color.fromRGBO(255, 255, 255, 1);
  Color dark  = Color.fromRGBO(53, 57, 63, 1);
  
  Color get getLightColor => light;
  Color get getDarkColor  => dark;
}

class ThemeColors
{
  static Background     background     = Background();
  static TileShadow     tileShadow     = TileShadow();
  static TileBrightness tileBrightness = TileBrightness();
}

class PlayerColors
{
  static Color user = Colors.indigo;
  static Color algo = Colors.purple;
}
