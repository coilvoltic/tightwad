import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tightwad/src/dev/game/components/background.dart';
import 'package:tightwad/src/dev/game/components/common/options/big_button.dart';
import 'package:tightwad/src/dev/game/components/common/options/blur.dart';
import 'package:tightwad/src/dev/game/components/common/options/settings_buttons.dart';
import 'package:tightwad/src/dev/game/components/confettis.dart';
import 'package:tightwad/src/dev/game/components/level_path.dart';
import 'package:tightwad/src/dev/game/components/map.dart';
import 'package:tightwad/src/dev/game/components/scores.dart';
import 'package:tightwad/src/dev/game/components/statement.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';
import 'package:tightwad/src/utils/common_enums.dart';

import 'components/common/options/modes_buttons.dart';


class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

  EntityNotifier entityNotifier = Provider.of<EntityNotifier>(context, listen: true);
    
  return Stack(
      children: [
        const Background(),
        (entityNotifier.getEntity == Entity.singleplayer) ? const LevelPath() : Container(),
        const Scores(),
        (entityNotifier.getEntity == Entity.singleplayer) ? const Map() : Container(),
        (entityNotifier.getEntity == Entity.singleplayer) ? const Confettis() : Container(),
        const Blur(),
        (entityNotifier.getEntity == Entity.singleplayer) ? const Statement() : Container(),
        const BigButton(),
        const SettingsButtons(),
        const ModesButtons(),
      ],
    );
  }
}
