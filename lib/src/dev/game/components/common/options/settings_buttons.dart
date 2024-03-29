import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/dev/game/components/common/options/flow_settings_delegate.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';
import 'package:tightwad/src/notifiers/game_handler_notifier.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';

import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/nothing.dart';
import 'package:tightwad/src/utils/option_button_package.dart';
import 'package:tightwad/src/utils/utils.dart';

class SettingsButtons extends StatefulWidget {
  const SettingsButtons({ Key? key }) : super(key: key);

  @override
  State<SettingsButtons> createState() => _SettingsButtonsState();
}

class _SettingsButtonsState extends State<SettingsButtons> with SingleTickerProviderStateMixin {

  late AnimationController _settingsControler;
  late OptionsNotifier     _optionsNotifier;
  late EntityNotifier      _entityNotifier;
  late MultiPlayerNotifier _mpNotifier;
  late GameHandlerNotifier _ghNotifier;
  bool _areSettingsChanging = false;

  double _gamePxSize     = 0.0;
  double _iconSize       = 0.0;
  double _buttonSize     = 0.0;
  double _offsetSize     = 0.0;
  double _xMarginOffset  = 0.0;
  double _yMarginOffset  = 0.0;
  double _borderRadius   = 0.0;

  final double _blurRadius        = 4.0;

  @override
  void initState() {
    _settingsControler = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _optionsNotifier = OptionsNotifier();
    _entityNotifier = EntityNotifier();
    _ghNotifier = GameHandlerNotifier();
    _mpNotifier = MultiPlayerNotifier();
    super.initState();
  }

  @override
  void dispose() {
    _settingsControler.dispose();
    super.dispose();
  }

  void constantsCalculation() {
      final double height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
      final double width  = MediaQuery.of(context).size.width;
      
      _gamePxSize     = min(min(width, height) / 1, height / 1.7);
      _iconSize       = 7.8 + _gamePxSize / 24 ;
      _buttonSize     = 15  + _gamePxSize / 12 ;
      _offsetSize     =       _gamePxSize / 150;
      _xMarginOffset  =       _gamePxSize / 20 ;
      _yMarginOffset  = 4 * ((height - min(min(width, height) / 1, height / 1.7)) / 2 - (2 * _buttonSize)) / 7 + _buttonSize;
      _borderRadius   =       _gamePxSize / 30 ;
  }

  void updateSettingsController() {
    if (_settingsControler.status == AnimationStatus.completed) {
      _settingsControler.reverse();
    } else {
      _settingsControler.forward();
    }
  }

  GestureDetector buildSettingButton(OptionButtonPackage optionButtonPackage) {
    return GestureDetector(
      onTap: () => {
        if (optionButtonPackage.type == OptionButtonType.main) {
          _optionsNotifier.updateSettingsChaning(),
        } else if (optionButtonPackage.type == OptionButtonType.theme) {
          _optionsNotifier.changeTheme(optionButtonPackage.theme)
        } else if (optionButtonPackage.type == OptionButtonType.volume) {
          _optionsNotifier.changeVolume(),
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS),
        width: _buttonSize,
        height: _buttonSize,
        decoration: Utils.buildNeumorphismBox(_borderRadius,
                                              _blurRadius,
                                              _offsetSize,
                                              optionButtonPackage.isPressed),
        child: Icon(
          optionButtonPackage.icon,
          color: Utils.getIconColorFromTheme(),
          size: _iconSize,
        ),
      ),
    );
  }

  Flow buildSettingsButtons() {
    return Flow(
      delegate: FlowSettingsDelegate(
        controller: _settingsControler,
        buttonSize: _buttonSize,
        xPos: MediaQuery.of(context).size.width  - _xMarginOffset - _buttonSize,
        yPos: MediaQuery.of(context).size.height - _yMarginOffset - _buttonSize),
      children: <OptionButtonPackage> [
        OptionButtonPackage(icon: Database.getSoundSettingOn() ? Icons.volume_up : Icons.volume_off,
                            type: OptionButtonType.volume, isPressed: Database.getSoundSettingOn()),
        OptionButtonPackage(icon: Icons.light_mode, theme: GameTheme.light,   type: OptionButtonType.theme, isPressed: Utils.isPressedFromTheme(GameTheme.light)),
        OptionButtonPackage(icon: Icons.dark_mode,  theme: GameTheme.dark,    type: OptionButtonType.theme, isPressed: Utils.isPressedFromTheme(GameTheme.dark)),
        OptionButtonPackage(icon: Icons.diamond,    theme: GameTheme.diamond, type: OptionButtonType.theme, isPressed: Utils.isPressedFromTheme(GameTheme.diamond)),
        OptionButtonPackage(icon: _optionsNotifier.getAreSettingsChanging ? Icons.close : Icons.settings,
                            type: OptionButtonType.main),
      ].map<Widget>(buildSettingButton).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _optionsNotifier = Provider.of<OptionsNotifier>    (context, listen: true);
    _ghNotifier      = Provider.of<GameHandlerNotifier>(context, listen: true);
    _entityNotifier  = Provider.of<EntityNotifier>     (context, listen: true);
    _mpNotifier      = Provider.of<MultiPlayerNotifier>(context, listen: true);
    
    constantsCalculation();
    if (_areSettingsChanging != _optionsNotifier.getAreSettingsChanging) {
      updateSettingsController();
      _areSettingsChanging = _optionsNotifier.getAreSettingsChanging;
    }

    if (_entityNotifier.getIsModeChanging ||
        (Database.getGameEntity() == Utils.SINGLEPLAYERGAME_ENTITY_INDEX && _ghNotifier.getGameStatus != GameStatus.playing) ||
        (Database.getGameEntity() == Utils.MULTIPLAYERGAME_ENTITY_INDEX  && _mpNotifier.getGameStatus != GameStatus.playing)) {
      return const Nothing();
    } else {
      return buildSettingsButtons();
    }
  }
}
