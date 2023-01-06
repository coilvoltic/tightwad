import 'package:flutter/material.dart';

class Background {
  Color light   = const Color.fromRGBO(231, 236, 239, 1);
  Color dark    = const Color.fromRGBO(46, 50, 57, 1);
  Color diamond = const Color.fromRGBO(9, 26, 51, 1);

  Color get getLightColor   => light;
  Color get getDarkColor    => dark;
  Color get getDiamondColor => diamond;
}

class TileShadow {
  Color light   = const Color.fromRGBO(167, 169, 175, 1);
  Color dark    = const Color.fromRGBO(35, 38, 42, 1);
  Color diamond = Colors.black;

  Color get getLightColor   => light;
  Color get getDarkColor    => dark;
  Color get getDiamondColor => diamond;
}

class TileBrightness {
  Color light   = const Color.fromRGBO(255, 255, 255, 1);
  Color dark    = const Color.fromRGBO(53, 57, 63, 1);
  Color diamond = const Color.fromRGBO(28, 81, 161, 1);
  
  Color get getLightColor   => light;
  Color get getDarkColor    => dark;
  Color get getDiamondColor => diamond;
}

class Icon {
  Color light   = const Color.fromRGBO(46, 50, 57, 1);
  Color dark    = const Color.fromRGBO(231, 236, 239, 1);
  Color diamond = const Color.fromRGBO(231, 236, 239, 1);
  // const Color.fromRGBO(29, 174, 214, 1)

  Color get getLightColor   => light;
  Color get getDarkColor    => dark;
  Color get getDiamondColor => diamond;
}

class Passed {
  Color light   = const Color.fromRGBO(46, 50, 57, 1);
  Color dark    = const Color.fromRGBO(231, 236, 239, 1);
  Color diamond = const Color.fromRGBO(231, 236, 239, 1);
  // const Color.fromRGBO(29, 174, 214, 1)

  Color get getLightColor   => light;
  Color get getDarkColor    => dark;
  Color get getDiamondColor => diamond;
}

class NotPassed {
  Color light   = Colors.white54;
  Color dark    = Colors.black12;
  Color diamond = Colors.black12;

  Color get getLightColor   => light;
  Color get getDarkColor    => dark;
  Color get getDiamondColor => diamond;
}

class LabelPassed {
  Color light   = const Color.fromRGBO(231, 236, 239, 1);
  Color dark    = const Color.fromRGBO(46, 50, 57, 1);
  Color diamond = Colors.black;

  Color get getLightColor   => light;
  Color get getDarkColor    => dark;
  Color get getDiamondColor => diamond;
}

class LabelNotPassed {
  Color light   = const Color.fromRGBO(46, 50, 57, 1);
  Color dark    = const Color.fromRGBO(231, 236, 239, 1);
  Color diamond = const Color.fromRGBO(231, 236, 239, 1);
  // const Color.fromRGBO(29, 174, 214, 1)

  Color get getLightColor   => light;
  Color get getDarkColor    => dark;
  Color get getDiamondColor => diamond;
}

class ThemeColors {
  static Background     background          = Background();
  static TileShadow     tileShadow          = TileShadow();
  static TileBrightness tileBrightness      = TileBrightness();
  static Icon           iconColor           = Icon();
  static Passed         passedColor         = Passed();
  static NotPassed      notPassedColor      = NotPassed();
  static LabelPassed    labelPassedColor    = LabelPassed();
  static LabelNotPassed labelNotPassedColor = LabelNotPassed();
}

class PlayerColors {
  static Color user = Colors.indigo;
  static Color algo = Colors.purple;
}
