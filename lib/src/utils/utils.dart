import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
  static const int SINGLEPLAYERGAME_ENTITY_INDEX = 1;
  // ignore: constant_identifier_names
  static const int MULTIPLAYERGAME_ENTITY_INDEX = 2;
  // ignore: constant_identifier_names
  static const int SINGLEPLAYERWELCOME_ENTITY_INDEX = 3;
  // ignore: constant_identifier_names
  static const int MULTIPLAYERWELCOME_ENTITY_INDEX = 4;

  // ignore: constant_identifier_names
  static const int THEME_ANIMATION_DURATION_MS = 150;

  // ignore: constant_identifier_names
  static const double ZERO_PLUS = 0.0001;
  // ignore: constant_identifier_names
  static const double ROOM_LOBBY_TITLE_HEIGHT_RATIO = 0.35;
  // ignore: constant_identifier_names
  static const double ROOM_LOBBY_ROOM_CHOICE_HEIGHT_RATIO = 0.12;
  // ignore: constant_identifier_names
  static const double ROOM_LOBBY_OPTIONS_HEIGHT_RATIO = 1 - (ROOM_LOBBY_TITLE_HEIGHT_RATIO + ROOM_LOBBY_ROOM_CHOICE_HEIGHT_RATIO) - ZERO_PLUS;
  // ignore: constant_identifier_names
  static const double ROOM_LOOBY_WIDTH_LIMIT_RATIO = 0.8;
  // ignore: constant_identifier_names
  static const double TEXT_FIELD_HEIGHT = 50;


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

  static Color getBackgroundColorFromGivenTheme(final GameTheme gameTheme) {
      if (gameTheme == GameTheme.light) {
        return ThemeColors.background.getLightColor;
      } else if (gameTheme == GameTheme.dark) {
        return ThemeColors.background.getDarkColor;
      } else if (gameTheme == GameTheme.diamond) {
        return ThemeColors.background.getDiamondColor;
      }
      return Colors.white;    
  }

  static Color getTileBrightnessColorFromTheme() {
      if (Database.getGameTheme() == LIGHT_THEME_INDEX) {
        return ThemeColors.tileBrightness.getLightColor;
      } else if (Database.getGameTheme() == DARK_THEME_INDEX) {
        return ThemeColors.tileBrightness.getDarkColor;
      } else if (Database.getGameTheme() == DIAMOND_THEME_INDEX) {
        return ThemeColors.tileBrightness.getDiamondColor;
      }
    return Colors.white;
  }

  static Color getTileBrightnessColorFromGivenTheme(final GameTheme gameTheme) {
      if (gameTheme == GameTheme.light) {
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

  static Color getTileShadowColorFromGivenTheme(final GameTheme gameTheme) {
      if (gameTheme == GameTheme.light) {
        return ThemeColors.tileShadow.getLightColor;
      } else if (gameTheme == GameTheme.dark) {
        return ThemeColors.tileShadow.getDarkColor;
      } else if (gameTheme == GameTheme.diamond) {
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

  static Color getLabelColorFromTheme() {
    if (Database.getGameTheme() == LIGHT_THEME_INDEX ||
        Database.getGameTheme() == DARK_THEME_INDEX) {
      return ThemeColors.labelColor.lightOrDark;
    } else if (Database.getGameTheme() == DIAMOND_THEME_INDEX) {
      return ThemeColors.labelColor.diamond;
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
    if (Database.getGameEntity() == SINGLEPLAYERGAME_ENTITY_INDEX && gameEntity == Entity.singleplayergame ||
        Database.getGameEntity() == MULTIPLAYERGAME_ENTITY_INDEX && gameEntity  == Entity.multiplayergame) {
      return true;
    }
    return false;
  }

  /// Informations.
  static BoxDecoration buildNeumorphismBox(final double     borderRadius,
                                           final double     blurRadius,
                                           final double     offset,
                                           final bool       isPressed,
                                           {final GameTheme? gameTheme}) {

    return BoxDecoration(
      color: gameTheme == null ? Utils.getBackgroundColorFromTheme() : Utils.getBackgroundColorFromGivenTheme(gameTheme),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          blurRadius: blurRadius,
          offset: -Offset(offset, offset),
          color: gameTheme == null ? Utils.getTileBrightnessColorFromTheme() : Utils.getTileBrightnessColorFromGivenTheme(gameTheme),
          inset: isPressed,
        ),
        BoxShadow(
          blurRadius: blurRadius,
          offset: Offset(offset, offset),
          color: gameTheme == null ? Utils.getTileShadowColorFromTheme() : Utils.getTileShadowColorFromGivenTheme(gameTheme),
          inset: isPressed,
        ),
      ]
    );
  }

  /// Informations.
  static BoxDecoration buildNeumorphismSwitchActivated(final double borderRadius,
                                                       final double blurRadius,
                                                       final double offset,
                                                       final bool   isPressed) {

    return BoxDecoration(
      color: Utils.getIconColorFromTheme(),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          blurRadius: blurRadius,
          offset: -Offset(offset, offset),
          color: Utils.getIconColorFromTheme(),
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

  static AnimatedContainer buildNeumorphicTextField(final String hintText,
                                                    final double width,
                                                    final TextEditingController controller) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS),
      height: Utils.TEXT_FIELD_HEIGHT,
      width: width,
      decoration: Utils.buildNeumorphismBox(50.0, 5.0, 5.0, true),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: TextField(
          controller: controller,
          cursorColor: Database.getGameTheme() == Utils.DIAMOND_THEME_INDEX ?
              ThemeColors.labelColor.diamond : ThemeColors.labelColor.lightOrDark,
          style: GoogleFonts.montserrat(
            color: Database.getGameTheme() == Utils.DIAMOND_THEME_INDEX ?
              ThemeColors.labelColor.diamond : ThemeColors.labelColor.lightOrDark,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'(\w+)'),
            ),
            FilteringTextInputFormatter.deny(
              RegExp(r'(\w{,8})'),
            ),
          ],
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: GoogleFonts.montserrat(
            color: Database.getGameTheme() == Utils.DIAMOND_THEME_INDEX ?
              ThemeColors.labelColor.diamond.withAlpha(70) : ThemeColors.labelColor.lightOrDark.withAlpha(100),
            fontWeight: FontWeight.bold,
            ),
          ),
          textInputAction: TextInputAction.done,
        ),
      ),
    );
  }

  static TweenAnimationBuilder buildNeumorphicSwitch(final bool isJoinRoom) {
    return TweenAnimationBuilder<Alignment>(
      tween: Tween<Alignment>(begin: Alignment.centerLeft, end: isJoinRoom ? Alignment.centerRight : Alignment.centerLeft),
      duration: const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS - 50),
      builder: (_, alignment, __) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS),
          height: 40,
          width: 80,
          decoration: Utils.buildNeumorphismBox(18.0, 3.0, 3.0, true),
          alignment: alignment,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS),
              height: 25,
              width: 25,
              decoration: isJoinRoom ? Utils.buildNeumorphismBox(25.0, 1.5, 1.5, false,
                gameTheme: Database.getGameTheme() == Utils.LIGHT_THEME_INDEX ? GameTheme.dark : GameTheme.light) :
                Utils.buildNeumorphismBox(25.0, 3.0, 3.0, false),
            ),
          ),
        );
      }
    );
  }

}
