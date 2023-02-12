import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';

import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/utils.dart';

class Statement2 extends StatefulWidget {
  const Statement2({Key? key}) : super(key: key);

  @override
  State<Statement2> createState() => _Statement2State();
}

class _Statement2State extends State<Statement2> {
  String _statement = '';
  int _sizeRatio = 0;
  List<String> winStatements = ["GREAT!", "WOW!", "PERFECT!"];
  int statementIndex = 0;
  bool _isDisplayedStatement = false;
  bool _reversed = false;
  bool _isStatementBouncing = false;
  int _currentRound = 0;

  void computeStatementVisibilityStatus(final MultiPlayerNotifier mpNotifier) {
    _isDisplayedStatement = mpNotifier.getGameStatus == GameStatus.win         ||
                            mpNotifier.getGameStatus == GameStatus.lose        ||
                            mpNotifier.getGameStatus == GameStatus.winsession  ||
                            mpNotifier.getGameStatus == GameStatus.losesession ||
                            mpNotifier.getGameStatus == GameStatus.drawsession ||
                            mpNotifier.getGameStatus == GameStatus.error       ||
                            mpNotifier.getGameStatus == GameStatus.retry;
  }

  void computeStatement(final MultiPlayerNotifier mpNotifier) {
    if (mpNotifier.getGameStatus == GameStatus.lose) {
      _statement = "YOU LOSE";
      _sizeRatio = 45;
    } else if (mpNotifier.getGameStatus == GameStatus.win) {
      if (_currentRound != mpNotifier.getCurrentRound) {
        _currentRound = mpNotifier.getCurrentRound;
        Random random = Random();
        statementIndex = random.nextInt(3);
        _statement = winStatements[statementIndex];
        _sizeRatio = statementIndex == 2 ? 38 : 50;
      }
    } else if (mpNotifier.getGameStatus == GameStatus.draw) {
      _statement = "DRAW";
      _sizeRatio = 50;
    } else if (mpNotifier.getGameStatus == GameStatus.winsession) {
      _statement = "VICTORY!";
      _sizeRatio = 40;
    } else if (mpNotifier.getGameStatus == GameStatus.losesession) {
      _statement = "DEFEAT!";
      _sizeRatio = 42;
    } else if (mpNotifier.getGameStatus == GameStatus.drawsession) {
      _statement = "NO WINNER!";
      _sizeRatio = 40;
    } else if (mpNotifier.getGameStatus == GameStatus.error) {
      _statement = "ERROR\nOCCURED";
      _sizeRatio = 30;
    } else if (mpNotifier.getGameStatus == GameStatus.retry) {
      _statement = "TAP TO\nRETRY!";
      _sizeRatio = 35;
    } else if (mpNotifier.getGameStatus == GameStatus.leavelostordraw ||
               mpNotifier.getGameStatus == GameStatus.leavewon) {
      _statement = "TAP TO\nLEAVE";
      _sizeRatio = 35;
    }
  }

  void computeStatementBouncingStatus(final MultiPlayerNotifier mpNotifier) {
    _isStatementBouncing = mpNotifier.getGameStatus == GameStatus.finish ||
        mpNotifier.getGameStatus == GameStatus.retry;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MultiPlayerNotifier>(builder: (context, mpNotifier, _) {
      computeStatement(mpNotifier);
      computeStatementVisibilityStatus(mpNotifier);
      computeStatementBouncingStatus(mpNotifier);
      return Visibility(
        visible: _isDisplayedStatement,
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: 0.0, end: _reversed ? -5.0 : 5.0),
          builder: (context, double statementPosition, child) {
            return SafeArea(
              child: Center(
                child: Transform.translate(
                  offset: Offset(
                      0.0, _isStatementBouncing ? statementPosition : 0.0),
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
              _reversed = !_reversed;
            }),
          },
        ),
      );
    });
  }
}
