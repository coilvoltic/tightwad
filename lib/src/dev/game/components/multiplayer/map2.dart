import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/dev/game/components/multiplayer/tile2.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/computation.dart';
import 'package:tightwad/src/utils/nothing.dart';

class Map2 extends StatefulWidget {
  const Map2({Key? key}) : super(key: key);

  @override
  State<Map2> createState() => _Map2State();
}

class _Map2State extends State<Map2> {

  double _height = 0.0;
  double _width  = 0.0;

  Widget buildMap(final MultiPlayerNotifier mpNotifier) {
    return SafeArea(
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width:  min(min(_width, _height) / 1, _height / 1.7),
          height: min(min(_width, _height) / 1, _height / 1.7),
          child: Align(
            alignment: Alignment.center,
            child: GridView.count(
              crossAxisCount: mpNotifier.getSqDim(),
              children: [
                for (int i = 0; i < pow(mpNotifier.getSqDim(), 2); i++)
                  Tile2(sqNbOfTiles:     mpNotifier.getSqDim(),
                        number:          mpNotifier.getMatrixElement(indexToCoordinates(i, mpNotifier.getSqDim())),
                        tileCoordinates: indexToCoordinates(i, mpNotifier.getSqDim())),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    MultiPlayerNotifier mpNotifier = Provider.of<MultiPlayerNotifier>(context, listen: true);

    _height = MediaQuery.of(context).size.height;
    _width  = MediaQuery.of(context).size.width;

    /** Initialization */
    if (mpNotifier.getGameStatus == GameStatus.loading) {
      if (MultiPlayerNotifier.shouldSessionBeInitialized) {
        mpNotifier.initializeSession();
      }
      mpNotifier.initializeGame();
      return const Nothing();
    } 

    /** Game */
    if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.creator &&
        mpNotifier.getTurn == Player.guest) {
      mpNotifier.listenToGuestMove();
    } else if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.guest &&
                mpNotifier.getTurn == Player.creator) {
      mpNotifier.listenToCreatorMove();
    }
    return buildMap(mpNotifier);
  }
}
