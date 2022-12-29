import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/colors.dart';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OptionsNotifier>(
      builder: (context, notifier, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: double.infinity,
          width: double.infinity,
          color: Database.getThemeSettingLight() ? ThemeColors.background.getLightColor : ThemeColors.background.getDarkColor,
        );
      }
    );
  }
}