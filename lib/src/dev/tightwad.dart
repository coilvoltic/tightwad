import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tightwad/src/dev/game/game.dart';
import 'package:tightwad/src/dev/tutorial/tutorial.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';
import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/utils/utils.dart';
 

class TightWadHome extends StatefulWidget {
  const TightWadHome({Key? key}) : super(key: key);

  @override
  State<TightWadHome> createState() => _TightWadHomeState();
}

class _TightWadHomeState extends State<TightWadHome> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EntityNotifier>(
      builder: (context, entityNotifier, _) {
        if (Database.getGameEntity() == Utils.TUTORIAL_ENTITY_INDEX) {
            return const Tutorial();
        } else {
            return const Game();
        }
      }
    );
  }
}