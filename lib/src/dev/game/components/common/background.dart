import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/utils.dart';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OptionsNotifier>(builder: (context, notifier, _) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS),
        height: double.infinity,
        width: double.infinity,
        color: Utils.getBackgroundColorFromTheme(),
      );
    });
  }
}
