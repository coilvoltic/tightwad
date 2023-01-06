import 'package:flutter/material.dart';
import 'package:tightwad/src/dev/game/components/common/options/modes_buttons.dart';
import 'package:tightwad/src/dev/game/components/common/options/settings_buttons.dart';

class MultiPlayer extends StatelessWidget {
  const MultiPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: const [
          Center(
            child: Text("multiplayer"),
          ),
          SettingsButtons(),
          ModesButtons(),
        ],
      ),
    );
  }
}