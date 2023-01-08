import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/dev/game/components/common/background.dart';

import 'package:tightwad/src/dev/game/components/common/big_button.dart';
import 'package:tightwad/src/dev/game/components/common/blur.dart';
import 'package:tightwad/src/dev/game/components/common/options/settings_buttons.dart';
import 'package:tightwad/src/dev/game/components/confettis.dart';
import 'package:tightwad/src/dev/game/components/level_path.dart';
import 'package:tightwad/src/dev/game/components/map.dart';
import 'package:tightwad/src/dev/game/components/multiplayer/room_lobby.dart';
import 'package:tightwad/src/dev/game/components/scores.dart';
import 'package:tightwad/src/dev/game/components/statement.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';
import 'package:tightwad/src/utils/utils.dart';

import 'components/common/options/modes_buttons.dart';


class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Consumer<EntityNotifier>(
      builder: (context, _, __) {
        if (Database.getGameEntity() == Utils.MULTIPLAYER_ENTITY_INDEX) {
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
    );
  }
}
