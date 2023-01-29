import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/dev/game/components/common/background.dart';

import 'package:tightwad/src/dev/game/components/common/big_button.dart';
import 'package:tightwad/src/dev/game/components/common/blur.dart';
import 'package:tightwad/src/dev/game/components/common/loading.dart';
import 'package:tightwad/src/dev/game/components/common/options/settings_buttons.dart';
import 'package:tightwad/src/dev/game/components/confettis.dart';
import 'package:tightwad/src/dev/game/components/level_path.dart';
import 'package:tightwad/src/dev/game/components/map.dart';
import 'package:tightwad/src/dev/game/components/multiplayer/map2.dart';
import 'package:tightwad/src/dev/game/components/multiplayer/room_lobby.dart';
import 'package:tightwad/src/dev/game/components/multiplayer/socres2.dart';
import 'package:tightwad/src/dev/game/components/multiplayer/waiting_opponent.dart';
import 'package:tightwad/src/dev/game/components/scores.dart';
import 'package:tightwad/src/dev/game/components/statement.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/utils.dart';
import 'package:tightwad/src/utils/welcome.dart';

import 'components/common/options/modes_buttons.dart';


class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  Stack buildLobby() {
    return Stack(
      children: const [
        Background(),
        RoomLobby(),
        Blur(),
        BigButton(),
        SettingsButtons(),
        ModesButtons(),
      ],
    );
  }

  Stack buildWaitingOpponent() {
    return Stack(
      children: const [
        Background(),
        WaitingOpponent(),
        Blur(),
        BigButton(),
        SettingsButtons(),
        ModesButtons(),
      ],
    );
  }

  Stack buildSinglePlayerGame() {
    return Stack(
      children: const [
        Background(),
        LevelPath(),
        Scores(),
        Map(),
        Confettis(),
        Blur(),
        Statement(),
        BigButton(),
        SettingsButtons(),
        ModesButtons(),
      ],
    );
  }

  Stack buildMultiPlayerGame() {
    return Stack(
      children: const [
        Background(),
        Scores2(),
        Map2(),
        Blur(),
        Statement(),
        BigButton(),
        SettingsButtons(),
        ModesButtons(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Consumer<EntityNotifier>(
          builder: (context, entityNotifier, __) {
            if (Database.getGameEntity() == Utils.LOBBY_ENTITY_INDEX) {
              return buildLobby();
            } else if (Database.getGameEntity() == Utils.WAITINGOPPONENT_ENTITY_INDEX) {
              return buildWaitingOpponent();
            } else if (Database.getGameEntity() == Utils.SINGLEPLAYERGAME_ENTITY_INDEX) {
              return buildSinglePlayerGame();
            } else if (Database.getGameEntity() == Utils.SINGLEPLAYERWELCOME_ENTITY_INDEX) {
              return const Welcome(destination: 'singleplayer', entityDestination: Entity.singleplayergame);
            } else if (Database.getGameEntity() == Utils.MULTIPLAYERWELCOME_ENTITY_INDEX) {
              return const Welcome(destination: 'multiplayer', entityDestination: Entity.lobby);
            } else if (Database.getGameEntity() == Utils.MULTIPLAYERGAME_ENTITY_INDEX) {
              return buildMultiPlayerGame();
            }
            return Container();
          }
        ),
        Consumer<MultiPlayerNotifier>(
          builder: (context, multiPlayerNotifier, __) {
            return Visibility(
              visible: multiPlayerNotifier.getGameStatus == GameStatus.loading,
              child: Container(
                color: Utils.getBackgroundColorFromTheme(),
                child: const Loading()
              ),
            );
          }
        ),
      ],
    );
  }
}

