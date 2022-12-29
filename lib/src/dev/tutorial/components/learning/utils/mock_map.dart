import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tightwad/src/dev/tutorial/components/learning/utils/mock_tile.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/computation.dart';
import 'package:tightwad/src/utils/tutorial_map_object.dart';

class MockMap extends StatefulWidget {
  const MockMap({Key? key,
                 required this.pageIndex,
                 }) : super(key: key);

  final int pageIndex;

  @override
  State<MockMap> createState() => _MockMapState();
}

class _MockMapState extends State<MockMap> {

  late final int nbOfPageMaps;
  int currentPageMap = 0;
  bool reversed = false;

  @override
  void initState() {
    nbOfPageMaps = pages[widget.pageIndex-1].length;
    super.initState();
  }

  bool computeIsForbidden(int tileIndex)
  {
    for (int i = 0; i < pages[widget.pageIndex-1][currentPageMap].forbiddenTiles.length; i++)
    {
      if (indexToCoordinates(tileIndex, tutorialSqNbOfTiles).x == pages[widget.pageIndex-1][currentPageMap].forbiddenTiles[i].x &&
          indexToCoordinates(tileIndex, tutorialSqNbOfTiles).y == pages[widget.pageIndex-1][currentPageMap].forbiddenTiles[i].y)
      {
        return true;
      }
    }
    return false;
  }

  Player computeOwner(int tileIndex)
  {
    for (int i = 0; i < pages[widget.pageIndex-1][currentPageMap].algoTiles.length; i++)
    {
      if (indexToCoordinates(tileIndex, tutorialSqNbOfTiles).x == pages[widget.pageIndex-1][currentPageMap].algoTiles[i].x &&
          indexToCoordinates(tileIndex, tutorialSqNbOfTiles).y == pages[widget.pageIndex-1][currentPageMap].algoTiles[i].y)
      {
        return Player.algo;
      }
    }
    for (int i = 0; i < pages[widget.pageIndex-1][currentPageMap].userTiles.length; i++)
    {
      if (indexToCoordinates(tileIndex, tutorialSqNbOfTiles).x == pages[widget.pageIndex-1][currentPageMap].userTiles[i].x &&
          indexToCoordinates(tileIndex, tutorialSqNbOfTiles).y == pages[widget.pageIndex-1][currentPageMap].userTiles[i].y)
      {
        return Player.user;
      }
    }
    return Player.none;
  }

  Widget buildGrid()
  {
    return GridView.count(
      crossAxisCount: tutorialSqNbOfTiles,
      children: [
        for (int i = 0; i < pow(tutorialSqNbOfTiles,2); i++)
          MockTile(sqNbOfTiles:     tutorialSqNbOfTiles,
                   number:          getMatrixElement(indexToCoordinates(i, tutorialSqNbOfTiles)),
                   tileCoordinates: indexToCoordinates(i,tutorialSqNbOfTiles),
                   owner:           computeOwner(i),
                   isForbidden:     computeIsForbidden(i)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width  = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width:  min(min(width, height) / 1, height / 2),
          height: min(min(width, height) / 1, height / 2),
          child: Align(
            alignment: Alignment.center,
            child: TweenAnimationBuilder(
              tween: Tween(begin: 0.0, end: reversed ? 1.0 : -1.0),
              duration: Duration(milliseconds: mapObjectsDelay[widget.pageIndex-1]),
              builder: (_, __, ___) {
                return buildGrid();
              },
              onEnd: () => setState(() {
                currentPageMap = (currentPageMap + 1) % nbOfPageMaps;
                reversed = !reversed;
              }),
            ),
          ),
        ),
      ),
    );
  }
}
