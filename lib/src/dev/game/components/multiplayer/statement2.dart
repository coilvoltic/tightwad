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

  void computeStatementVisibilityStatus(final MultiPlayerNotifier mpNotifier) {
    _isDisplayedStatement = mpNotifier.getGameStatus == GameStatus.win ||
                            mpNotifier.getGameStatus == GameStatus.lose;
  }

  void computeStatement(final MultiPlayerNotifier mpNotifier) {
    if (mpNotifier.getGameStatus == GameStatus.lose) {
      _statement = "YOU LOSE";
      _sizeRatio = 45;
    } else if (mpNotifier.getGameStatus == GameStatus.win) {
      Random random = Random();
      statementIndex = random.nextInt(3);
      _statement = winStatements[statementIndex];
      _sizeRatio = statementIndex == 2 ? 38 : 50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MultiPlayerNotifier>(builder: (context, mpNotifier, _) {
      computeStatementVisibilityStatus(mpNotifier);
      computeStatement(mpNotifier);
      print('KL statement:');
      print(_isDisplayedStatement);
      print(_statement);
      return SafeArea(
        child: Center(
          child: Visibility(
            visible: _isDisplayedStatement,
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
    });
  }
}