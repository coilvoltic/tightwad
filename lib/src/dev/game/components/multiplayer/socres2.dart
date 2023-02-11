import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/colors.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/responsive.dart';
import 'package:tightwad/src/utils/utils.dart';

class Scores2 extends StatefulWidget {
  const Scores2({super.key});

  @override
  State<Scores2> createState() => _Scores2State();
}

class _Scores2State extends State<Scores2> {

  double _height = 0.0;

  Widget buildSeparation() {
    return AnimatedContainer( 
      height: _height * 0.4 - 20,
      width: 2,
      duration: const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS),
      decoration: BoxDecoration(
        color: Utils.getIconColorFromTheme(),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
    );
  }

  Widget buildName(final String name, final MultiPlayerStatus player, final Color playerColor, final bool isTurn) {
    return Responsive(
      maxWidth: 300,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS),
        alignment: player == MultiPlayerStatus.creator ? Alignment.centerLeft : Alignment.centerRight,
        padding: player == MultiPlayerStatus.creator ? const EdgeInsets.only(left: 10.0) : const EdgeInsets.only(right: 10.0),
        height: 60,
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
          border: Border.all(
            color: isTurn ? Utils.getIconColorFromTheme() : Utils.getIconColorFromTheme().withAlpha(128),
            width: 2.0,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Text(
          name,
          style: TextStyle(
            fontFamily: 'Righteous',
            decoration: TextDecoration.none,
            fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 9),
            fontWeight: FontWeight.bold,
            color: isTurn ? playerColor : playerColor.withAlpha(128),
          ),
        ),
      ),
    );
  }

  Widget buildNames(final String creatorName, final String guestName, final Player turn) {
    return Responsive(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildName(creatorName, MultiPlayerStatus.creator, PlayerColors.creator, turn == Player.creator),
            buildName(guestName, MultiPlayerStatus.guest, PlayerColors.guest, turn == Player.guest),
          ],
        ),
      ),
    );
  }

  Widget buildScore(final int score, final Color playerColor) {
    return Text(
      '$score',
      style: TextStyle(
        fontFamily: 'Righteous',
        decoration: TextDecoration.none,
        fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 13),
        fontWeight: FontWeight.bold,
        color: playerColor,
      ),
    );
  }

  Widget buildScores(final int creatorScore, final int guestScore) {
    return Responsive(
      maxWidth: 150,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS),
        height: _height * 0.4,
        width: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
          color: Utils.getBackgroundColorFromTheme(),
          border: Border.all(
            color: Utils.getIconColorFromTheme(),
            width: 4.0
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15.0))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildScore(creatorScore, PlayerColors.creator),
            buildSeparation(),
            buildScore(guestScore, PlayerColors.guest),
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height -
                          (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom);
    final double width  = MediaQuery.of(context).size.width;

    _height = (height - min(min(width, height) / 1, height / 1.7)) / 2;

    return Consumer2<MultiPlayerNotifier, OptionsNotifier>(
      builder: (context, mpNotifier, _, __) {
        return SafeArea(
          child: SizedBox(
            height: _height,
            child: Stack(
              children: [
                buildNames(mpNotifier.getCreatorName, mpNotifier.getGuestName, mpNotifier.getTurn),
                buildScores(mpNotifier.getCreatorScore, mpNotifier.getGuestScore),
              ],
            ),
          ),
        );
      }
    );
  }
}
