import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';
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
    required this.tileCoordinates,
  }) : super(key: key);

  final int sqNbOfTiles;
  final int number;
  final Coordinates tileCoordinates;
  final player = AudioPlayer();

  @override
  State<Tile2> createState() => _Tile2State();
}

class _Tile2State extends State<Tile2> {

  Player owner = Player.none;

  void playSound(final String soundPath) async {
    await widget.player.play(AssetSource(soundPath));
  }

  Widget createChild(double minDimension) {
    Color textColor = Colors.white;

    if (owner == Player.creator) {
      textColor = PlayerColors.creator.withAlpha(200);
    } else if (owner == Player.guest) {
      textColor = PlayerColors.guest.withAlpha(200);
    } else if (Utils.shouldGlow()) {
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

  void checkOpponentMove(MultiPlayerNotifier mpNotifier) {
    if (owner == Player.none) {
      if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.guest && mpNotifier.getCreatorLastMove() == widget.tileCoordinates) {
        setState(() {
          owner = Player.creator;
        });
      } else if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.creator && mpNotifier.getGuestLastMove() == widget.tileCoordinates) {
        setState(() {
          owner = Player.guest;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    MultiPlayerNotifier mpNotifier = Provider.of<MultiPlayerNotifier>(context, listen: true);

    return Consumer<OptionsNotifier>(
      builder: (context, _, __) {
      if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.creator &&
          mpNotifier.getTurn == Player.guest) {
        mpNotifier.listenToGuestMove();
      } else if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.guest &&
                  mpNotifier.getTurn == Player.creator) {
        mpNotifier.listenToCreatorMove();
      }
      checkOpponentMove(mpNotifier);
      return GestureDetector(
        onTap: () => setState(() {
          if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.creator &&
              mpNotifier.getTurn == Player.creator) {
            mpNotifier.notifyCreatorNewMove(widget.tileCoordinates);
            owner = Player.creator;
          } else if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.guest &&
                     mpNotifier.getTurn == Player.guest) {
            mpNotifier.notifyGuestNewMove(widget.tileCoordinates);
            owner = Player.guest;
          }
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: EdgeInsets.all(-0.6 * widget.sqNbOfTiles + 8),
          width: double.infinity,
          height: double.infinity,
          decoration: Utils.buildNeumorphismBox(45.0 - 5 * widget.sqNbOfTiles,
              5.0, 6.5 - widget.sqNbOfTiles / 2, owner != Player.none),
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
