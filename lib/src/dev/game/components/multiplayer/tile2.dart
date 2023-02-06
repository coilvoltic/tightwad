import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/colors.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/coordinates.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/utils/game_utils.dart';
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
  bool _isMoveForbidden = false;

  void playSound(final String soundPath) async {
    await widget.player.play(AssetSource(soundPath));
  }

  Widget createChild(double minDimension) {
    Color textColor = Colors.white;

    if (owner == Player.creator) {
      textColor = PlayerColors.creator.withAlpha(200);
    } else if (owner == Player.guest) {
      textColor = PlayerColors.guest.withAlpha(200);
    } else if (_isMoveForbidden) {
      textColor = ThemeColors.labelColor.lightOrDark.withAlpha(50); 
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
    print('check opponent move');
    print('owner is : ${owner.toString()}');
    if (owner == Player.none) {
      print('owner is none');
      print('1: x = ${mpNotifier.getCreatorLastMove().x}, y = ${mpNotifier.getCreatorLastMove().y}');
      print('2: x = ${mpNotifier.getGuestLastMove().x}, y = ${mpNotifier.getGuestLastMove().y}');
      if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.guest && GameUtils.areCoordinatesEqual(widget.tileCoordinates, mpNotifier.getCreatorLastMove())) {
        if (Database.getSoundSettingOn() && mpNotifier.getNbOfCreatorPress() > 0) {
          playSound('player1-${mpNotifier.getNbOfCreatorPress()}.mp3');
        }
        print('creator');
        owner = Player.creator;
      } else if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.creator && GameUtils.areCoordinatesEqual(widget.tileCoordinates, mpNotifier.getGuestLastMove())) {
        if (Database.getSoundSettingOn() && mpNotifier.getNbOfGuestPress() > 0) {
          playSound('player2-${mpNotifier.getNbOfGuestPress()}.wav');
        }
        print('guest');
        owner = Player.guest;
      }
    }
  }

  void getUpdatedToOpponentMove(MultiPlayerNotifier mpNotifier) {
    if (mpNotifier.getIsNewEvent) {
      checkOpponentMove(mpNotifier);
      mpNotifier.resetNewEvent();
    }
  }

  void checkWhetherMoveIsForbidden(MultiPlayerNotifier mpNotifier) {
    if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.creator) {
      _isMoveForbidden = mpNotifier.isForbiddenCreatorMove(widget.tileCoordinates);
    } else if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.guest) {
      _isMoveForbidden = mpNotifier.isForbiddenGuestMove(widget.tileCoordinates);
    }
  }

  @override
  Widget build(BuildContext context) {

    MultiPlayerNotifier mpNotifier = Provider.of<MultiPlayerNotifier>(context, listen: true);

    return Consumer<OptionsNotifier>(
      builder: (context, _, __) {
      getUpdatedToOpponentMove(mpNotifier);
      checkWhetherMoveIsForbidden(mpNotifier);
      return GestureDetector(
        onTap: () => {
          if (owner == Player.none && !_isMoveForbidden) {
            if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.creator &&
                mpNotifier.getTurn == Player.creator) {
              if (Database.getSoundSettingOn()) {
                playSound('player1-${mpNotifier.getNbOfCreatorPress() + 1}.mp3'),
              },
              owner = Player.creator,
              mpNotifier.updateLocalCreatorTiles(widget.tileCoordinates),
              mpNotifier.notifyCreatorNewMove(widget.tileCoordinates),
            } else if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.guest &&
                      mpNotifier.getTurn == Player.guest) {
              if (Database.getSoundSettingOn()) {
                playSound('player2-${mpNotifier.getNbOfGuestPress() + 1}.wav'),
              },
              owner = Player.guest,
              mpNotifier.updateLocalGuestTiles(widget.tileCoordinates),
              mpNotifier.notifyGuestNewMove(widget.tileCoordinates),
            }
          }
        },
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
