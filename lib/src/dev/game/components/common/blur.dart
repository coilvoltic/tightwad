import 'dart:ui';

import 'package:tightwad/src/notifiers/entity_notifier.dart';
import 'package:tightwad/src/notifiers/game_handler_notifier.dart';
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
                  EntityNotifier      entityNotifier) {
    _isDisplayedBlur = (gameHandlerNotifier.getGameStatus != GameStatus.playing ||
                       optionsNotifier.getAreSettingsChanging ||
                       entityNotifier.getIsModeChanging);
    if (gameHandlerNotifier.getGameStatus != GameStatus.playing) {
      _blurAnimationDuration = 1000;
      _blurValue = 4.0;
    } else if (optionsNotifier.getAreSettingsChanging || entityNotifier.getIsModeChanging) {
      _blurAnimationDuration = 100;
      _blurValue = 4.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Consumer3<GameHandlerNotifier, OptionsNotifier, EntityNotifier>(
      builder: (context, gameHandlerNotifier, optionsNotifier, entityNotifier, _) {
        updateBlur(gameHandlerNotifier, optionsNotifier, entityNotifier);
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