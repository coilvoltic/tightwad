import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/notifiers/game_handler_notifier.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/colors.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/coordinates.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/utils/utils.dart';

class Tile2 extends StatefulWidget {
  Tile2({
    Key? key,
    required this.sqNbOfTiles,
    required this.number,
  }) : super(key: key);

  final int sqNbOfTiles;
  final int number;
  final player = AudioPlayer();

  @override
  State<Tile2> createState() => _Tile2State();
}

class _Tile2State extends State<Tile2> {

  void playSound(final String soundPath) async {
    await widget.player.play(AssetSource(soundPath));
  }

  Widget createChild(double minDimension) {
    Color textColor = Colors.white;

    if (Utils.shouldGlow()) {
      textColor = ThemeColors.labelColor.diamond.withAlpha(170);
    } else {
      textColor = ThemeColors.labelColor.lightOrDark.withAlpha(200);
    }

    return GlowText(
      '${widget.number}',
      blurRadius: Utils.shouldGlow() ? 2.5 : 0.0,
      glowColor: Utils.shouldGlow() ? textColor : Colors.transparent,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Inter',
        decoration: TextDecoration.none,
        fontSize: minDimension / widget.sqNbOfTiles * 55 / 130,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GameHandlerNotifier, OptionsNotifier>(
        builder: (context, gameHandlerNotifier, optionsNotifier, _) {
      return GestureDetector(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: EdgeInsets.all(-0.6 * widget.sqNbOfTiles + 8),
          width: double.infinity,
          height: double.infinity,
          decoration: Utils.buildNeumorphismBox(45.0 - 5 * widget.sqNbOfTiles,
              5.0, 6.5 - widget.sqNbOfTiles / 2, false),
          child: Center(
            child: createChild(min(
                min(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height) /
                    1,
                MediaQuery.of(context).size.height / 1.7)),
          ),
        ),
      );
    });
  }
}
