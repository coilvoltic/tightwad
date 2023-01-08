import 'dart:math';

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tightwad/src/dev/game/components/common/options/flow_mode_delegate.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';

import 'package:provider/provider.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/common_enums.dart';
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
  bool _isModeChanging = false;

  double _gamePxSize     = 0.0;
  double _iconSize       = 0.0;
  double _buttonSize     = 0.0;
  double _offsetSize     = 0.0;
  double _xMarginOffset  = 0.0;
  double _yMarginOffset  = 0.0;
  double _borderRadius   = 0.0;

  final double _blurRadius        = 4.0;
  final int    _animationDuration = 150;

  @override
  void initState() {
    _modeController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _entityNotifier  = EntityNotifier();
    super.initState();
  }

  @override
  void dispose() {
    _entityNotifier.dispose();
    _modeController.dispose();
    super.dispose();
  }

  void constantsCalculation() {
      final double height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
      final double width  = MediaQuery.of(context).size.width;
      
      _gamePxSize     = min(min(width, height) / 1, height / 1.7);
      _iconSize       = 7.8 + _gamePxSize / 24 ;
      _buttonSize     = 15  + _gamePxSize / 12 ;
      _offsetSize     =       _gamePxSize / 100;
      _xMarginOffset  =       _gamePxSize / 20 ;
      _yMarginOffset  =  15 +       width / 20 ;
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
          _entityNotifier.changeGameEntity(optionButtonPackage.mode)
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: _animationDuration),
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
        OptionButtonPackage(icon: FontAwesomeIcons.one, type: OptionButtonType.mode, mode: Entity.singleplayer, isPressed: Utils.isPressedFromGameEntity(Entity.singleplayer)),
        OptionButtonPackage(icon: Icons.double_arrow, type: OptionButtonType.mode, mode: Entity.multiplayer, isPressed: Utils.isPressedFromGameEntity(Entity.multiplayer)),
        OptionButtonPackage(icon: _entityNotifier.getIsModeChanging ? Icons.close : Icons.mode,
                            type: OptionButtonType.main),
      ].map<Widget>(buildModeButton).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _entityNotifier = Provider.of<EntityNotifier>(context, listen: true);
    
    constantsCalculation();
    if (_isModeChanging != _entityNotifier.getIsModeChanging) {
      updateModeController();
      _isModeChanging = _entityNotifier.getIsModeChanging;
    }
    return Consumer<OptionsNotifier>(
      builder: (context, optionsNotifier, __) {
        if (optionsNotifier.getAreSettingsChanging) {
          return Container();
        } else {
          return buildModesButtons();
        }
      }
    );
  }
}
