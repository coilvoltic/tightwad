import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/dev/game/components/multiplayer/tile2.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/computation.dart';

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
                  Tile2(sqNbOfTiles:    mpNotifier.getSqDim(),
                        number:         mpNotifier.getMatrixElement(indexToCoordinates(i, mpNotifier.getSqDim())),),
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

    if (mpNotifier.getGameStatus == GameStatus.loading) {
      if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.creator) {
        return FutureBuilder(
          builder: (BuildContext _, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData && snapshot.data! == true) {
              mpNotifier.setGameStatus(GameStatus.playing);
            }
            return Container();
          },
          future: mpNotifier.createAndPushMatrix(),
        );
      } else if (MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.guest) {
        return StreamBuilder(
          builder: ((context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            print('guest builder');
            if (snapshot.hasData && snapshot.data!.get('matrix') != '') {
              print('set matrix!');
              mpNotifier.setMatrix(jsonDecode(snapshot.data!.get('matrix')));
              mpNotifier.setGameStatus(GameStatus.playing, shouldNotify: false);
            }
            return Container();
          }),
          stream: FirebaseFirestore.instance.collection('rooms').doc('room-${Database.getRoomId()}').snapshots(),
        );      
      }
      return Container();
    } else {
      return buildMap(mpNotifier);
    }
  }
}
