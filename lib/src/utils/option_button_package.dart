import 'package:flutter/material.dart';
import 'package:tightwad/src/utils/common_enums.dart';

class OptionButtonPackage {
  
    const OptionButtonPackage({
      required this.icon,
      required this.type,
      this.theme = GameTheme.none,
      this.isPressed = false,
      this.mode = Entity.none
    });

    final IconData         icon;
    final OptionButtonType type;
    final GameTheme        theme;
    final bool             isPressed;
    final Entity           mode;

}
