import 'dart:math';

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/dev/game/components/options/flow_theme_men_delegate.dart';

import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/colors.dart';
import 'package:provider/provider.dart';

class OptionButtons extends StatefulWidget {
  const OptionButtons({ Key? key }) : super(key: key);

  @override
  State<OptionButtons> createState() => _OptionButtonsState();
}

class _OptionButtonsState extends State<OptionButtons> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late OptionsNotifier _optionsNotifier;

  double _gamePxSize   = 0.0;
  double _iconSize     = 0.0;
  double _buttonSize   = 0.0;
  double _offsetSize   = 0.0;
  double _marginOffset = 0.0;
  double _borderRadius = 0.0;

  final double _blurRadius        = 4.0;
  final int    _animationDuration = 150;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _optionsNotifier.dispose();
    super.dispose();
  }

  void constantsCalculation() {
      final double height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
      final double width  = MediaQuery.of(context).size.width;
      
      _gamePxSize   = min(min(width, height) / 1, height / 1.7);
      _iconSize     = 7.8 + _gamePxSize / 24 ;
      _buttonSize   = 15  + _gamePxSize / 12 ;
      _offsetSize   =       _gamePxSize / 100;
      _marginOffset =       _gamePxSize / 20 ;
      _borderRadius =       _gamePxSize / 30 ;
  }

  GestureDetector buildThemeButton(IconData icon) {
    return GestureDetector(
      onTap: () => setState(() {
        _optionsNotifier.updateThemeChanging();
        if (_controller.status == AnimationStatus.completed) {
          _controller.reverse();
        } else {
          _controller.forward();
        }
      }),
      child: AnimatedContainer(
        duration: Duration(milliseconds: _animationDuration),
        width: _buttonSize,
        height: _buttonSize,
        decoration: BoxDecoration(
          color: Database.getThemeSettingLight() ? ThemeColors.background.getLightColor : ThemeColors.background.getDarkColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          boxShadow: [
            BoxShadow(
              blurRadius: _blurRadius,
              offset: -Offset(_offsetSize, _offsetSize),
              color: Database.getThemeSettingLight() ? ThemeColors.tileBrightness.getLightColor : ThemeColors.tileBrightness.getDarkColor,
              inset: !Database.getThemeSettingLight(),
            ),
            BoxShadow(
              blurRadius: _blurRadius,
              offset: Offset(_offsetSize, _offsetSize),
              color: Database.getThemeSettingLight() ? ThemeColors.tileShadow.getLightColor : ThemeColors.tileShadow.getDarkColor,
              inset: !Database.getThemeSettingLight(),
            ),
          ]
        ),
        child: Icon(
          icon,
          color: Database.getThemeSettingLight() ? ThemeColors.background.getDarkColor : ThemeColors.background.getLightColor,
          size: _iconSize,
        ),
      ),
    );
  }

  Flow buildThemeButtons() {
    return Flow(
      delegate: FlowThemeMenuDelegate(
        controller: _controller,
        buttonSize: _buttonSize,
        xPos: MediaQuery.of(context).size.width  - _marginOffset - _buttonSize,
        yPos: MediaQuery.of(context).size.height - _marginOffset - _buttonSize),
      children: <IconData> [
        Icons.dark_mode,
        Icons.light_mode,
        Icons.diamond,
        _optionsNotifier.getIsThemeChanging ? Icons.close : Icons.color_lens,
      ].map<Widget>(buildThemeButton).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OptionsNotifier>(
      builder: (context, notifier, _) {
        _optionsNotifier = notifier;
        constantsCalculation();
        return buildThemeButtons();
      }
    );
  }
}
