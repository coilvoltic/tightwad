import 'dart:ui';

import 'package:tightwad/src/notifiers/entity_notifier.dart';
import 'package:tightwad/src/notifiers/game_handler_notifier.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Blur extends StatefulWidget {
  const Blur({Key? key}) : super(key: key);

  @override
  State<Blur> createState() => _BlurState();
}

class _BlurState extends State<Blur> {

  bool   _isDisplayedBlur       = false;
  int    _blurAnimationDuration = 0;
  double _blurValue             = 0.0;

  void updateBlur(GameHandlerNotifier gameHandlerNotifier,
                  OptionsNotifier     optionsNotifier,
                  EntityNotifier      entityNotifier,
                  MultiPlayerNotifier mpNotifier) {
    _isDisplayedBlur = (gameHandlerNotifier.getGameStatus != GameStatus.playing ||
                       optionsNotifier.getAreSettingsChanging ||
                       entityNotifier.getIsModeChanging ||
                       mpNotifier.getGameStatus == GameStatus.win         ||
                       mpNotifier.getGameStatus == GameStatus.lose        ||
                       mpNotifier.getGameStatus == GameStatus.error       ||
                       mpNotifier.getGameStatus == GameStatus.losesession ||
                       mpNotifier.getGameStatus == GameStatus.drawsession ||
                       mpNotifier.getGameStatus == GameStatus.winsession  ||
                       mpNotifier.getGameStatus == GameStatus.retry       ||
                       mpNotifier.getGameStatus == GameStatus.alone       ||
                       mpNotifier.getGameStatus == GameStatus.leavewon    ||
                       mpNotifier.getGameStatus == GameStatus.leavelostordraw);
    if (gameHandlerNotifier.getGameStatus != GameStatus.playing ||
        mpNotifier.getGameStatus == GameStatus.win              ||
        mpNotifier.getGameStatus == GameStatus.lose             ||
        mpNotifier.getGameStatus == GameStatus.losesession      || 
        mpNotifier.getGameStatus == GameStatus.drawsession      || 
        mpNotifier.getGameStatus == GameStatus.winsession       ||
        mpNotifier.getGameStatus == GameStatus.retry            ||
        mpNotifier.getGameStatus == GameStatus.alone            ||
        mpNotifier.getGameStatus == GameStatus.leavewon         ||
        mpNotifier.getGameStatus == GameStatus.leavelostordraw) { 
      _blurAnimationDuration = 1000;
      _blurValue = 4.0;
    } else if (optionsNotifier.getAreSettingsChanging ||
               entityNotifier.getIsModeChanging       ||
               mpNotifier.getGameStatus == GameStatus.error) {
      _blurAnimationDuration = 100;
      _blurValue = 4.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Consumer4<GameHandlerNotifier, OptionsNotifier, EntityNotifier, MultiPlayerNotifier>(
      builder: (context, gameHandlerNotifier, optionsNotifier, entityNotifier, mpNotifier, _) {
        updateBlur(gameHandlerNotifier, optionsNotifier, entityNotifier, mpNotifier);
        return Visibility(
          visible: _isDisplayedBlur,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.01, end: _blurValue),
            duration: Duration(milliseconds: _blurAnimationDuration),
            builder: (_, blurValue, __) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
                ),
              );
            }
          ),
        );
      }
    );

  }
}