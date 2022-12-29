import 'dart:math';

import 'package:tightwad/src/notifiers/game_handler_notifier.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/colors.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/coordinates.dart';
import 'package:tightwad/src/database/database.dart';

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class Tile extends StatefulWidget {
  const Tile({Key? key,
              required this.sqNbOfTiles,
              required this.number,
              required this.tileCoordinates,
              }) : super(key: key);

  final int         sqNbOfTiles;
  final int         number;
  final Coordinates tileCoordinates;

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {

  bool   lastAnimationWasPressing = false;
  Player owner                    = Player.none;
  bool   isForbiddenMove          = false;
  bool   isRebuilt                = false;

  Widget createChild(double minDimension)
  {
    Color textColor = Colors.white;

    if (owner == Player.algo)
    {
      textColor = PlayerColors.algo.withAlpha(200);
    }
    else if (isForbiddenMove)
    {
      textColor = Colors.grey.withAlpha(50);
    }
    else if (owner == Player.user)
    {
      textColor = PlayerColors.user.withAlpha(200);
    }
    else
    {
      textColor = Colors.grey.withAlpha(200);
    }

    return Text(
      '${widget.number}',
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        decoration: TextDecoration.none,
        fontSize: minDimension / widget.sqNbOfTiles * 55 / 130,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  void checkAlgoPress(GameHandlerNotifier gameHandlerNotifier)
  {
    if (widget.tileCoordinates.x == gameHandlerNotifier.getAlgoPress.x &&
        widget.tileCoordinates.y == gameHandlerNotifier.getAlgoPress.y)
    {
      owner = Player.algo;
    }
  }
  
  void checkTileReset(GameHandlerNotifier gameHandlerNotifier)
  {
    if (gameHandlerNotifier.getGameStatus == GameStatus.playing)
    {
      if (!isRebuilt)
      {
        owner = Player.none;
        isRebuilt = true;
      }
    }
    else
    {
      isRebuilt = false;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer2<GameHandlerNotifier, OptionsNotifier>(
      builder: (context, gameHandlerNotifier, optionsNotifier, _) {
        isForbiddenMove = gameHandlerNotifier.isForbiddenMove(widget.tileCoordinates);
        checkAlgoPress(gameHandlerNotifier);
        checkTileReset(gameHandlerNotifier);
        return GestureDetector(
          onTap: () => setState(() {
            if (!isForbiddenMove && !(owner == Player.user) && gameHandlerNotifier.canUserMove)
            {
              owner = Player.user;
              lastAnimationWasPressing = true;
              gameHandlerNotifier.registerUserMove(widget.tileCoordinates);
              gameHandlerNotifier.algoTurn();
            }
          }),
          child: AnimatedContainer(
            onEnd: () => setState(() {
              if (lastAnimationWasPressing)
              {
                owner = Player.user;
                lastAnimationWasPressing = false;
              }
            }),
            duration: const Duration(milliseconds: 150),
            margin: EdgeInsets.all(-0.6 * widget.sqNbOfTiles + 8),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Database.getThemeSettingLight() ? ThemeColors.background.getLightColor : ThemeColors.background.getDarkColor,
              borderRadius: BorderRadius.circular(23.0 - 2 * widget.sqNbOfTiles),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4.0,
                  offset: -Offset(6.5 - widget.sqNbOfTiles / 2, 6.5 - widget.sqNbOfTiles / 2),
                  color: Database.getThemeSettingLight() ? ThemeColors.tileBrightness.getLightColor : ThemeColors.tileBrightness.getDarkColor,
                  inset: owner != Player.none,
                ),
                BoxShadow(
                  blurRadius: 4.0,
                  offset: Offset(6.5 - widget.sqNbOfTiles / 2, 6.5 - widget.sqNbOfTiles / 2),
                  color: Database.getThemeSettingLight() ? ThemeColors.tileShadow.getLightColor : ThemeColors.tileShadow.getDarkColor,
                  inset: owner != Player.none,
                ),
              ]
            ),
            child: Center(
              child: createChild(
                min(min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) / 1, MediaQuery.of(context).size.height / 1.7)
              ),
            ),
          ),
        );
      }
    );
  }
}