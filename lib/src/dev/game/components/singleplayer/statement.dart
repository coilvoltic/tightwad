import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/notifiers/game_handler_notifier.dart';
import 'package:tightwad/src/utils/utils.dart';

class Statement extends StatefulWidget {
  const Statement({Key? key}) : super(key: key);

  @override
  State<Statement> createState() => _StatementState();
}

class _StatementState extends State<Statement> {
  String _statement = "";
  int _sizeRatio = 0;
  List<String> winStatements = ["GREAT!", "WOW!", "PERFECT!"];
  int statementIndex = 0;
  bool _isDisplayedStatement = false;

  bool reversed = false;
  bool isStatementBouncing = false;
  int currentLvl = -1;

  void computeStatementVisibilityStatus(GameHandlerNotifier notifier) {
    _isDisplayedStatement = notifier.getGameStatus != GameStatus.playing;
  }

  void computeStatement(GameHandlerNotifier notifier) {
    if (notifier.getGameStatus == GameStatus.lose) {
      _statement = "YOU LOSE";
      _sizeRatio = 45;
    } else if (notifier.getGameStatus == GameStatus.win) {
      if (currentLvl != notifier.getLvl) {
        Random random = Random();
        statementIndex = random.nextInt(3);
        currentLvl = notifier.getLvl;
      }
      _statement = winStatements[statementIndex];
      _sizeRatio = statementIndex == 2 ? 38 : 50;
    } else if (notifier.getGameStatus == GameStatus.nextlevel) {
      _statement = "TAP TO\nNEXT!";
      _sizeRatio = 35;
    } else if (notifier.getGameStatus == GameStatus.tryagain) {
      _statement = "TRY AGAIN!";
      _sizeRatio = 45;
    } else if (notifier.getGameStatus == GameStatus.finish) {
      _statement = "YOU'RE A\nHEROE!";
      _sizeRatio = 40;
    }
  }

  void computeStatementBouncingStatus(GameHandlerNotifier notifier) {
    isStatementBouncing = notifier.getGameStatus == GameStatus.nextlevel ||
        notifier.getGameStatus == GameStatus.tryagain ||
        notifier.getGameStatus == GameStatus.finish;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameHandlerNotifier>(builder: (context, notifier, _) {
      computeStatementVisibilityStatus(notifier);
      return Visibility(
        visible: _isDisplayedStatement,
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: 0.0, end: reversed ? -5.0 : 5.0),
          builder: (context, double statementPosition, child) {
            computeStatement(notifier);
            computeStatementBouncingStatus(notifier);
            return SafeArea(
              child: Center(
                child: Transform.translate(
                  offset: Offset(
                      0.0, isStatementBouncing ? statementPosition : 0.0),
                  child: Text(
                    _statement,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Righteous',
                      decoration: TextDecoration.none,
                      fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, _sizeRatio.toDouble()),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          },
          onEnd: () => {
            setState(() {
              reversed = !reversed;
            }),
          },
        ),
      );
    });
  }
}
