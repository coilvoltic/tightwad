import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/dev/game/components/common/options/flow_mode_delegate.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';

import 'package:provider/provider.dart';
import 'package:tightwad/src/notifiers/game_handler_notifier.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/nothing.dart';
import 'package:tightwad/src/utils/option_button_package.dart';
import 'package:tightwad/src/utils/utils.dart';

class ModesButtons extends StatefulWidget {
  const ModesButtons({ Key? key }) : super(key: key);

  @override
  State<ModesButtons> createState() => _ModesButtonsState();
}

class _ModesButtonsState extends State<ModesButtons> with SingleTickerProviderStateMixin {

  late AnimationController _modeController;
  late EntityNotifier      _entityNotifier;
  late GameHandlerNotifier _ghNotifier;
  late OptionsNotifier     _optionsNotifier;
  late MultiPlayerNotifier _mpNotifier;
  
  bool _isModeChanging = false;

  double _gamePxSize     = 0.0;
  double _iconSize       = 0.0;
  double _buttonSize     = 0.0;
  double _offsetSize     = 0.0;
  double _xMarginOffset  = 0.0;
  double _yMarginOffset  = 0.0;
  double _borderRadius   = 0.0;

  final double _blurRadius = 4.0;

  @override
  void initState() {
    _modeController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _entityNotifier = EntityNotifier();
    _ghNotifier = GameHandlerNotifier();
    _optionsNotifier = OptionsNotifier();
    _mpNotifier = MultiPlayerNotifier();
    super.initState();
  }

  @override
  void dispose() {
    _modeController.dispose();
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
      _yMarginOffset  = 3 * ((height - min(min(width, height) / 1, height / 1.7)) / 2 - (2 * _buttonSize)) / 7;
      _borderRadius   =       _gamePxSize / 30 ;
  }

  void updateModeController() {
    if (_modeController.status == AnimationStatus.completed) {
      _modeController.reverse();
    } else {
      _modeController.forward();
    }
  }

  GestureDetector buildModeButton(OptionButtonPackage optionButtonPackage) {
    return GestureDetector(
      onTap: () => {
        if (optionButtonPackage.type == OptionButtonType.main) {
          _entityNotifier.updateModeChanging(),
        } else if (optionButtonPackage.type == OptionButtonType.mode) {
          _entityNotifier.updateModeChanging(),
          if (!optionButtonPackage.isPressed) {
            _entityNotifier.changeGameEntity(optionButtonPackage.mode),
          },
          if (optionButtonPackage.mode == Entity.singleplayerwelcome) {
            _ghNotifier.resetLevel(),
          }
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

  Flow buildModesButtons() {
    return Flow(
      delegate: FlowModeDelegate(
        controller: _modeController,
        buttonSize: _buttonSize,
        xPos: MediaQuery.of(context).size.width  - _xMarginOffset - _buttonSize,
        yPos: MediaQuery.of(context).size.height - _yMarginOffset - _buttonSize),
      children: <OptionButtonPackage> [
        OptionButtonPackage(icon: Icons.person, type: OptionButtonType.mode, mode: Entity.singleplayerwelcome, isPressed: Utils.isPressedFromGameEntity(Entity.singleplayergame)),
        OptionButtonPackage(icon: Icons.group, type: OptionButtonType.mode, mode: Entity.multiplayerwelcome, isPressed: Utils.isPressedFromGameEntity(Entity.multiplayergame)),
        OptionButtonPackage(icon: _entityNotifier.getIsModeChanging ? Icons.close : Icons.home,
                            type: OptionButtonType.main),
      ].map<Widget>(buildModeButton).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _entityNotifier  = Provider.of<EntityNotifier>(context, listen: true);
    _ghNotifier      = Provider.of<GameHandlerNotifier>(context, listen: true);
    _optionsNotifier = Provider.of<OptionsNotifier>(context, listen: true);
    _mpNotifier      = Provider.of<MultiPlayerNotifier>(context, listen: true);
    
    constantsCalculation();
    if (_isModeChanging != _entityNotifier.getIsModeChanging) {
      updateModeController();
      _isModeChanging = _entityNotifier.getIsModeChanging;
    }
    if (_optionsNotifier.getAreSettingsChanging ||
        (Database.getGameEntity() == Utils.SINGLEPLAYERGAME_ENTITY_INDEX && _ghNotifier.getGameStatus != GameStatus.playing) ||
        (Database.getGameEntity() == Utils.MULTIPLAYERGAME_ENTITY_INDEX  && _mpNotifier.getGameStatus != GameStatus.playing)) {
        return const Nothing();
      } else {
        return buildModesButtons();
      }
    }
}
