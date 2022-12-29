import 'package:tightwad/src/dev/game/components/level_path.dart';
import 'package:flutter/material.dart';

import 'package:tightwad/src/dev/game/components/background.dart';
import 'package:tightwad/src/dev/game/components/scores.dart';
import 'package:tightwad/src/dev/game/components/option_buttons.dart';
import 'package:tightwad/src/dev/game/components/map.dart';
import 'package:tightwad/src/dev/game/components/confettis.dart';
import 'package:tightwad/src/dev/game/components/blur.dart';
import 'package:tightwad/src/dev/game/components/statement.dart';
import 'package:tightwad/src/dev/game/components/big_button.dart';

class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        Background(),
        LevelPath(),
        Scores(),
        OptionButtons(),
        Map(),
        Confettis(),
        Blur(),
        Statement(),
        BigButton(),
      ],
    );
  }
}