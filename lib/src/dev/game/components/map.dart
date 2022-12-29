import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tightwad/src/dev/game/components/tile.dart';
import 'package:tightwad/src/notifiers/game_handler_notifier.dart';
import 'package:tightwad/src/utils/computation.dart';
import 'package:tightwad/src/utils/common_enums.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {

  bool _isRebuilt = false;

  int _sqNbOfTiles = 1;
  late Widget _grid;

  void computeGrid(GameHandlerNotifier gameHandlerNotifier)
  {
    _grid = GridView.count(
      crossAxisCount: _sqNbOfTiles,
      children: [
        for (int i = 0; i < pow(_sqNbOfTiles, 2); i++)
          Tile(sqNbOfTiles:     _sqNbOfTiles,
               number:          gameHandlerNotifier.getMatrixElement(indexToCoordinates(i, _sqNbOfTiles)),
               tileCoordinates: indexToCoordinates(i,_sqNbOfTiles)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameHandlerNotifier>(
      builder: (context, gameHandlerNotifier, _) {
        if (gameHandlerNotifier.getGameStatus == GameStatus.playing)
        {
          if (!_isRebuilt)
          {
            _sqNbOfTiles = gameHandlerNotifier.getSqNbOfTiles;
            computeGrid(gameHandlerNotifier);
            
            _isRebuilt = true;
          }
        }
        else
        {
          _isRebuilt = false;
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
                child: Stack
                (
                  children: [
                    Container(
                      // color: PlayerColors.user,
                    ),
                    _grid,
                  ]
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}