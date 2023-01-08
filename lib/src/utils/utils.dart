import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/utils/colors.dart';

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

import 'common_enums.dart';

class Utils {

  // ignore: constant_identifier_names
  static const int LIGHT_THEME_INDEX = 0;
  // ignore: constant_identifier_names
  static const int DARK_THEME_INDEX = 1;
  // ignore: constant_identifier_names
  static const int DIAMOND_THEME_INDEX = 2;

  // ignore: constant_identifier_names
  static const int TUTORIAL_ENTITY_INDEX = 0;
  // ignore: constant_identifier_names
  static const int SINGLEPLAYER_ENTITY_INDEX = 1;
  // ignore: constant_identifier_names
  static const int MULTIPLAYER_ENTITY_INDEX = 2;


  static Color getBackgroundColorFromTheme() {
    if (Database.getGameTheme() == LIGHT_THEME_INDEX) {
      return ThemeColors.background.getLightColor;
    } else if (Database.getGameTheme() == DARK_THEME_INDEX) {
      return ThemeColors.background.getDarkColor;
    } else if (Database.getGameTheme() == DIAMOND_THEME_INDEX) {
      return ThemeColors.background.getDiamondColor;
    }
    return Colors.white;
  }

  static Color getTileBrightessColorFromTheme() {
    if (Database.getGameTheme() == LIGHT_THEME_INDEX) {
      return ThemeColors.tileBrightness.getLightColor;
    } else if (Database.getGameTheme() == DARK_THEME_INDEX) {
      return ThemeColors.tileBrightness.getDarkColor;
    } else if (Database.getGameTheme() == DIAMOND_THEME_INDEX) {
      return ThemeColors.tileBrightness.getDiamondColor;
    }
    return Colors.white;
  }

  static Color getTileShadowColorFromTheme() {
    if (Database.getGameTheme() == LIGHT_THEME_INDEX) {
      return ThemeColors.tileShadow.getLightColor;
    } else if (Database.getGameTheme() == DARK_THEME_INDEX) {
      return ThemeColors.tileShadow.getDarkColor;
    } else if (Database.getGameTheme() == DIAMOND_THEME_INDEX) {
      return ThemeColors.tileShadow.getDiamondColor;
    }
    return Colors.white;
  }

  static Color getIconColorFromTheme() {
    if (Database.getGameTheme() == LIGHT_THEME_INDEX) {
      return ThemeColors.iconColor.getLightColor;
    } else if (Database.getGameTheme() == DARK_THEME_INDEX) {
      return ThemeColors.iconColor.getDarkColor;
    } else if (Database.getGameTheme() == DIAMOND_THEME_INDEX) {
      return ThemeColors.iconColor.getDiamondColor;
    }
    return Colors.white;
  }

  static Color getNotPassedColorFromTheme() {
    if (Database.getGameTheme() == LIGHT_THEME_INDEX) {
      return ThemeColors.notPassedColor.light;
    } else if (Database.getGameTheme() == DARK_THEME_INDEX) {
      return ThemeColors.notPassedColor.dark;
    } else if (Database.getGameTheme() == DIAMOND_THEME_INDEX) {
      return ThemeColors.notPassedColor.diamond;
    }
    return Colors.white;
  }

  static Color getPassedColorFromTheme() {
    if (Database.getGameTheme() == LIGHT_THEME_INDEX) {
      return ThemeColors.passedColor.light;
    } else if (Database.getGameTheme() == DARK_THEME_INDEX) {
      return ThemeColors.passedColor.dark;
    } else if (Database.getGameTheme() == DIAMOND_THEME_INDEX) {
      return ThemeColors.passedColor.diamond;
    }
    return Colors.white;
  }

  static Color getLabelNotPassedColorFromTheme() {
    if (Database.getGameTheme() == LIGHT_THEME_INDEX) {
      return ThemeColors.labelNotPassedColor.light;
    } else if (Database.getGameTheme() == DARK_THEME_INDEX) {
      return ThemeColors.labelNotPassedColor.dark;
    } else if (Database.getGameTheme() == DIAMOND_THEME_INDEX) {
      return ThemeColors.labelNotPassedColor.diamond;
    }
    return Colors.white;
  }

  static Color getLabelPassedColorFromTheme() {
    if (Database.getGameTheme() == LIGHT_THEME_INDEX) {
      return ThemeColors.labelPassedColor.light;
    } else if (Database.getGameTheme() == DARK_THEME_INDEX) {
      return ThemeColors.labelPassedColor.dark;
    } else if (Database.getGameTheme() == DIAMOND_THEME_INDEX) {
      return ThemeColors.labelPassedColor.diamond;
    }
    return Colors.white;
  }

  static bool shouldGlow() {
    return Database.getGameTheme() == DIAMOND_THEME_INDEX;
  }

  static bool isPressedFromTheme(final GameTheme buttonGameTheme) {
    if (Database.getGameTheme() == LIGHT_THEME_INDEX   && buttonGameTheme == GameTheme.light ||
        Database.getGameTheme() == DARK_THEME_INDEX    && buttonGameTheme == GameTheme.dark  ||
        Database.getGameTheme() == DIAMOND_THEME_INDEX && buttonGameTheme == GameTheme.diamond) {
      return true;
    }
    return false;
  }

  static bool isPressedFromGameEntity(final Entity gameEntity) {
    if (Database.getGameEntity() == SINGLEPLAYER_ENTITY_INDEX && gameEntity == Entity.singleplayer ||
        Database.getGameEntity() == MULTIPLAYER_ENTITY_INDEX && gameEntity  == Entity.multiplayer) {
      return true;
    }
    return false;
  }

  /// Informations.
  static BoxDecoration buildNeumorphismBox(final double borderRadius,
                                           final double blurRadius,
                                           final double offset,
                                           final bool   isPressed) {

    return BoxDecoration(
      color: Utils.getBackgroundColorFromTheme(),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          blurRadius: blurRadius,
          offset: -Offset(offset, offset),
          color: Utils.getTileBrightessColorFromTheme(),
          inset: isPressed,
        ),
        BoxShadow(
          blurRadius: blurRadius,
          offset: Offset(offset, offset),
          color: Utils.getTileShadowColorFromTheme(),
          inset: isPressed,
        ),
      ]
    );
  }

}
