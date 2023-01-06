import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/notifiers/game_handler_notifier.dart';
import 'package:tightwad/src/utils/colors.dart';
import 'package:tightwad/src/utils/utils.dart';

class Scores extends StatefulWidget {
  const Scores({Key? key}) : super(key: key);

  @override
  State<Scores> createState() => _ScoresState();
}

class _ScoresState extends State<Scores> {

  Widget buildUserIcon(OptionsNotifier optionsNotifier, double gamePxSize)
  {
    return FaIcon(
      FontAwesomeIcons.userLarge,
      size: gamePxSize / 12,
      color: Utils.getIconColorFromTheme(),
    );
  }

  Widget buildUserScore(GameHandlerNotifier gameHandlerNotifier, double gamePxSize)
  {
    return Container(
      margin: EdgeInsets.only(top: gamePxSize / 240),
      child: Text(
        '${gameHandlerNotifier.getUserScore}',
        style: GoogleFonts.inter(
          decoration: TextDecoration.none,
          fontSize: gamePxSize / 14,
          fontWeight: FontWeight.bold,
          color: PlayerColors.user,
        ),
      ),
    );
  }

  Widget buildAlgoIcon(OptionsNotifier optionsNotifier, double gamePxSize)
  {
    return FaIcon(
      FontAwesomeIcons.robot,
      size: gamePxSize / 12,
      color: Utils.getIconColorFromTheme(),
    );
  }

  Widget buildAlgoScore(GameHandlerNotifier gameHandlerNotifier, double gamePxSize)
  {
    return Container(
      margin: EdgeInsets.only(top: gamePxSize / 120),
      child: Text(
        '${gameHandlerNotifier.getAlgoScore}',
        style: GoogleFonts.inter(
          decoration: TextDecoration.none,
          fontSize: gamePxSize / 14,
          fontWeight: FontWeight.bold,
          color: PlayerColors.algo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width  = MediaQuery.of(context).size.width;
    final double gamePxSize = min(min(width, height) / 1, height / 1.7);

    return Consumer2<GameHandlerNotifier, OptionsNotifier>(
      builder: (context, gameHandlerNotifier, optionsNotifier, _) {
        return SafeArea(
          child: SizedBox(
            height: gamePxSize / 3.3,
            child: Column(
              children: [
                SizedBox(
                  height: gamePxSize / 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [    
                    SizedBox(
                      width: gamePxSize / 30,
                    ), 
                    Container(
                      height: gamePxSize / 10,
                      width: gamePxSize / 8,
                      alignment: Alignment.center,
                      child: buildUserIcon(optionsNotifier, gamePxSize),
                    ),
                    SizedBox(
                      width: gamePxSize / 100,
                    ),
                    Container(
                      height: gamePxSize / 10,
                      alignment: Alignment.centerLeft,
                      child: buildUserScore(gameHandlerNotifier, gamePxSize)
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: gamePxSize / 30,
                    ),
                    Container(
                      height: gamePxSize / 10,
                      width: gamePxSize / 8,
                      alignment: Alignment.center,
                      child: buildAlgoIcon(optionsNotifier, gamePxSize),
                    ),
                    SizedBox(
                      width: gamePxSize / 100,
                    ),
                    Container(
                      height: gamePxSize / 10,
                      alignment: Alignment.centerLeft,
                      child: buildAlgoScore(gameHandlerNotifier, gamePxSize)
                    ),
                  ],
                ),
              ]
            ),
          ),
        );
      }
    );
  }
}