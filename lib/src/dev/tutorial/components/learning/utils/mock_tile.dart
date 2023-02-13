import 'dart:math';

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;

import 'package:tightwad/src/utils/colors.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/coordinates.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:tightwad/src/utils/utils.dart';

class MockTile extends StatefulWidget {
  const MockTile({
    Key? key,
    required this.sqNbOfTiles,
    required this.number,
    required this.tileCoordinates,
    required this.owner,
    required this.isForbidden,
  }) : super(key: key);

  final int sqNbOfTiles;
  final int number;
  final Coordinates tileCoordinates;
  final Player owner;
  final bool isForbidden;

  @override
  State<MockTile> createState() => _MockTileState();
}

class _MockTileState extends State<MockTile> {
  Text createChild(double minDimension) {
    Color textColor = Colors.white;

    if (widget.owner == Player.algo) {
      textColor = PlayerColors.algo.withAlpha(200);
    } else if (widget.owner == Player.user) {
      textColor = PlayerColors.user.withAlpha(200);
    } else if (widget.isForbidden) {
      textColor = Colors.grey.withAlpha(50);
    } else {
      textColor = Colors.grey.withAlpha(200);
    }

    return Text(
      '${widget.number}',
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.all(-0.6 * widget.sqNbOfTiles + 8),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Utils.getBackgroundColorFromTheme(),
        borderRadius: BorderRadius.circular(45.0 - 5 * widget.sqNbOfTiles),
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            offset: -Offset(
                6.5 - widget.sqNbOfTiles / 2, 6.5 - widget.sqNbOfTiles / 2),
            color: Utils.getTileBrightnessColorFromTheme(),
            inset: widget.owner != Player.none,
          ),
          BoxShadow(
            blurRadius: 4.0,
            offset: Offset(
                6.5 - widget.sqNbOfTiles / 2, 6.5 - widget.sqNbOfTiles / 2),
            color: Utils.getTileShadowColorFromTheme(),
            inset: widget.owner != Player.none,
          ),
        ],
      ),
      child: Center(
        child: createChild(min(
            min(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height) /
                1,
            MediaQuery.of(context).size.height / 2)),
      ),
    );
  }
}
