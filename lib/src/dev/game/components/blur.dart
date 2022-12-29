import 'dart:ui';

import 'package:tightwad/src/notifiers/game_handler_notifier.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Blur extends StatefulWidget {
  const Blur({Key? key}) : super(key: key);

  @override
  State<Blur> createState() => _BlurState();
}

class _BlurState extends State<Blur> {

  bool _isDisplayedBlur = false;

  void updateBlur(GameHandlerNotifier notifier)
  {
    _isDisplayedBlur = notifier.getGameStatus != GameStatus.playing;
  }

  @override
  Widget build(BuildContext context) {
    
    return Consumer<GameHandlerNotifier>(
      builder: (context, notifier, _) {
        updateBlur(notifier);
        return Visibility(
          visible: _isDisplayedBlur,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.01, end: 4.0),
            duration: const Duration(seconds: 1),
            builder: (_, blurValue, __)
            {
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