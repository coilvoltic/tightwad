import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';

import 'package:tightwad/src/notifiers/game_handler_notifier.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/common_enums.dart';

class BigButton extends StatefulWidget {
  const BigButton({Key? key}) : super(key: key);

  @override
  BigButtonState createState() => BigButtonState();
}

class BigButtonState extends State<BigButton> {

  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {

    GameHandlerNotifier gameHandlerNotifier = Provider.of<GameHandlerNotifier>(context, listen: true);
    OptionsNotifier     optionsNotifier     = Provider.of<OptionsNotifier>(context, listen: true);
    EntityNotifier      entityNotifier      = Provider.of<EntityNotifier>(context, listen: true);
    MultiPlayerNotifier mpNotifier          = Provider.of<MultiPlayerNotifier>(context, listen: true);

    final bool dueToGameHandler = gameHandlerNotifier.getGameStatus == GameStatus.nextlevel ||
                                  gameHandlerNotifier.getGameStatus == GameStatus.tryagain  ||
                                  gameHandlerNotifier.getGameStatus == GameStatus.finish;
    final bool dueToSettings    = optionsNotifier.getAreSettingsChanging;
    final bool dueToMode        = entityNotifier.getIsModeChanging;
    final bool dueToError       = mpNotifier.getGameStatus == GameStatus.error       ||
                                  mpNotifier.getGameStatus == GameStatus.winsession  ||
                                  mpNotifier.getGameStatus == GameStatus.losesession ||
                                  mpNotifier.getGameStatus == GameStatus.drawsession;

    _isVisible = dueToMode || dueToSettings || dueToGameHandler || dueToError;

    return Visibility(
      visible: _isVisible,
      child: Center(
        child: SizedBox.expand(
          child: TextButton(
            onPressed: () => {
              if (dueToError) {
                entityNotifier.changeGameEntity(Entity.multiplayerwelcome),
                mpNotifier.setGameStatus(GameStatus.none),
              } else if (dueToMode) {
                entityNotifier.updateModeChanging(),
              } else if (dueToSettings) {
                optionsNotifier.updateSettingsChaning(),
              } else if (dueToGameHandler) {
                gameHandlerNotifier.setIsPlaying(),
              }
            },
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
