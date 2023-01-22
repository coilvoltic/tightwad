import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/dev/game/components/multiplayer/tile2.dart';
import 'package:tightwad/src/notifiers/loading_notifier.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';
import 'package:tightwad/src/utils/common_enums.dart';

import '../../../../utils/computation.dart';

class Map2 extends StatelessWidget {
  const Map2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    LoadingNotifier     loadingNotifier = Provider.of<LoadingNotifier>(context, listen: false);
    MultiPlayerNotifier mpNotifier      = Provider.of<MultiPlayerNotifier>(context, listen: true);

    if (mpNotifier.getGameStatus == GameStatus.none) {
      loadingNotifier.setIsLoading();
      if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.creator) {
        mpNotifier.generateAndPushNewMatrix();
        mpNotifier.waitForGuestToReceiveMatrix();
      } else if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.guest) {
        mpNotifier.fetchMatrix();
        mpNotifier.notifyMatrixReceived();
      }
      loadingNotifier.unsetIsLoading();
    }

    final double height = MediaQuery.of(context).size.height;
    final double width  = MediaQuery.of(context).size.width;
    
    return SafeArea(
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width:  min(min(width, height) / 1, height / 1.7),
          height: min(min(width, height) / 1, height / 1.7),
          child: Align(
            alignment: Alignment.center,
            child: GridView.count(
              crossAxisCount: mpNotifier.getSqDim(),
              children: [
                for (int i = 0; i < pow(mpNotifier.getSqDim(), 2); i++)
                  Tile2(sqNbOfTiles:    mpNotifier.getSqDim(),
                        number:         mpNotifier.getMatrixElement(indexToCoordinates(i, mpNotifier.getSqDim())),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
