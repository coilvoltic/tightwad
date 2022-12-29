import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tightwad/src/notifiers/game_handler_notifier.dart';
import 'package:tightwad/src/utils/common_enums.dart';

class BigButton extends StatefulWidget {
  const BigButton({Key? key}) : super(key: key);

  @override
  BigButtonState createState() => BigButtonState();
}

class BigButtonState extends State<BigButton> {

  bool isVisible = false;

  void updateGame(GameHandlerNotifier notifier)
  {
    notifier.setIsPlaying();
  }

  void updateVisibility(GameHandlerNotifier notifier)
  {
    isVisible = notifier.getGameStatus == GameStatus.nextlevel ||
                notifier.getGameStatus == GameStatus.tryagain  ||
                notifier.getGameStatus == GameStatus.finish;
  }

  @override
  Widget build(BuildContext context) {

    GameHandlerNotifier notifier = Provider.of<GameHandlerNotifier>(context);
    updateVisibility(notifier);

    return Visibility(
      visible: isVisible,
      child: Center(
        child: SizedBox.expand(
          child: TextButton(
            onPressed: () => updateGame(notifier),
            style: const ButtonStyle(
              splashFactory: NoSplash.splashFactory,
            ),
            child: const Text(""),
          ),
        ),
      ),
    );
  }
}
