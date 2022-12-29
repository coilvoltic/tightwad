import 'dart:math';

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:tightwad/src/database/database.dart';

import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/colors.dart';
import 'package:provider/provider.dart';

class OptionButtons extends StatefulWidget {
  const OptionButtons({ Key? key }) : super(key: key);

  @override
  State<OptionButtons> createState() => _OptionButtonsState();
}

class _OptionButtonsState extends State<OptionButtons> {

  Widget buildThemeButton(OptionsNotifier notifier, double gamePxSize)
  {
    return GestureDetector(
      onTap: () => setState(() {
        notifier.changeTheme();
        notifier.updateThemeChanging();
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: EdgeInsets.only(
          right: gamePxSize / 20,
        ),
        width: 15 + gamePxSize / 12,
        height: 15 + gamePxSize / 12,
        decoration: BoxDecoration(
          color: Database.getThemeSettingLight() ? ThemeColors.background.getLightColor : ThemeColors.background.getDarkColor,
          borderRadius: BorderRadius.circular(gamePxSize / 30),
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              offset: -Offset(gamePxSize/100, gamePxSize/100),
              color: Database.getThemeSettingLight() ? ThemeColors.tileBrightness.getLightColor : ThemeColors.tileBrightness.getDarkColor,
              inset: !Database.getThemeSettingLight(),
            ),
            BoxShadow(
              blurRadius: 4.0,
              offset: Offset(gamePxSize/100, gamePxSize/100),
              color: Database.getThemeSettingLight() ? ThemeColors.tileShadow.getLightColor : ThemeColors.tileShadow.getDarkColor,
              inset: !Database.getThemeSettingLight(),
            ),
          ]
        ),
        child: Icon(
          Database.getThemeSettingLight() ? Icons.dark_mode : Icons.light_mode,
          color: Database.getThemeSettingLight() ? ThemeColors.background.getDarkColor : ThemeColors.background.getLightColor,
          size: 7.8 + gamePxSize / 24,
        ),
      ),
    );
  }

  Widget buildSoundButton(OptionsNotifier notifier, double gamePxSize)
  {
    return GestureDetector(
      onTap: () => setState(() {
        notifier.changeVolume();
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: EdgeInsets.only(
          right: gamePxSize / 20,
          bottom: min(max(gamePxSize / 20 - MediaQuery.of(context).padding.top, MediaQuery.of(context).padding.top), gamePxSize / 20),
        ),
        width: 15 + gamePxSize / 12,
        height: 15 + gamePxSize / 12,
        decoration: BoxDecoration(
          color: Database.getThemeSettingLight() ? ThemeColors.background.getLightColor : ThemeColors.background.getDarkColor,
          borderRadius: BorderRadius.circular(gamePxSize / 30),
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              offset: -Offset(gamePxSize/100, gamePxSize/100),
              color: Database.getThemeSettingLight() ? ThemeColors.tileBrightness.getLightColor : ThemeColors.tileBrightness.getDarkColor,
              inset: Database.getSoundSettingOn(),
            ),
            BoxShadow(
              blurRadius: 4.0,
              offset: Offset(gamePxSize/100, gamePxSize/100),
              color: Database.getThemeSettingLight() ? ThemeColors.tileShadow.getLightColor : ThemeColors.tileShadow.getDarkColor,
              inset: Database.getSoundSettingOn(),
            ),
          ]
        ),
        child: Icon(
          Database.getSoundSettingOn() ? Icons.volume_up : Icons.volume_off,
          color: Database.getThemeSettingLight() ? ThemeColors.background.getDarkColor : ThemeColors.background.getLightColor,
          size: 7.5 + gamePxSize / 24,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<OptionsNotifier>(
      builder: (context, notifier, _) {

        final double height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
        final double width  = MediaQuery.of(context).size.width;
        final double gamePxSize = min(min(width, height) / 1, height / 1.7);
        
        return SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildThemeButton(notifier, gamePxSize),
              const SizedBox(
                height: 10.0,
              ),
              buildSoundButton(notifier, gamePxSize),
            ],
          ),
        );
      }
    );
  }
}
