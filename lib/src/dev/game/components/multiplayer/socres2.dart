import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/colors.dart';
import 'package:tightwad/src/utils/utils.dart';

class Scores2 extends StatefulWidget {
  const Scores2({super.key});

  @override
  State<Scores2> createState() => _Scores2State();
}

class _Scores2State extends State<Scores2> {

  Widget buildCreatorScore(final MultiPlayerNotifier mpNotifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          MultiPlayerNotifier.creatorName,
          style: TextStyle(
            fontFamily: 'Righteous',
            decoration: TextDecoration.none,
            fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 20),
            fontWeight: FontWeight.bold,
            color: Utils.getPassedColorFromTheme().withAlpha(128),
          ),
        ),
        Text(
          mpNotifier.getCreatorScore.toString(),
          style: TextStyle(
            fontFamily: 'Righteous',
            decoration: TextDecoration.none,
            fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 15),
            fontWeight: FontWeight.bold,
            color: PlayerColors.creator,
          ),
        ),
      ],
    );
  }

  Widget buildGuestScore(final MultiPlayerNotifier mpNotifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          MultiPlayerNotifier.guestName,
          style: TextStyle(
            fontFamily: 'Righteous',
            decoration: TextDecoration.none,
            fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 20),
            fontWeight: FontWeight.bold,
            color: Utils.getPassedColorFromTheme(),
          ),
        ),
        Text(
          mpNotifier.getGuestScore.toString(),
          style: TextStyle(
            fontFamily: 'Righteous',
            decoration: TextDecoration.none,
            fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 15),
            fontWeight: FontWeight.bold,
            color: PlayerColors.guest,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MultiPlayerNotifier, OptionsNotifier>(
      builder: (context, mpNotifier, _, __) {
        final double height = MediaQuery.of(context).size.height;
        final double width  = MediaQuery.of(context).size.width;
        return Container(
          height: (height - min(min(width, height) / 1, height / 1.7)) / 2,
          // color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildCreatorScore(mpNotifier),
              buildGuestScore(mpNotifier),
            ],
          )
        );
      }
    );
  }
}