import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/responsive.dart';
import 'package:tightwad/src/utils/utils.dart';

class WaitingOpponent extends StatefulWidget {
  const WaitingOpponent({Key? key}) : super(key: key);

  @override
  State<WaitingOpponent> createState() => _WaitingOpponentState();
}

class _WaitingOpponentState extends State<WaitingOpponent> {

  bool _isPressedButton = false;
  bool _isReversed = false;

  Widget buildValidationButton(VoidCallback onTap) {
    return InkWell(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTapDown: (_) => setState(() {
        _isPressedButton = true;
      }),
      onTapUp: (_) => setState(() {
        _isPressedButton = false;
      }),
      onTap: onTap,
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS),
        height: Utils.TEXT_FIELD_HEIGHT,
        width: MediaQuery.of(context).size.width *
            Utils.ROOM_LOOBY_WIDTH_LIMIT_RATIO /
            2,
        decoration: Utils.buildNeumorphismBox(25.0, 5.0, 5.0, _isPressedButton),
        child: Center(
          child: TweenAnimationBuilder<double>(
            onEnd: () => setState(() {
                  _isReversed = !_isReversed;
                }),
            duration: const Duration(milliseconds: 300),
            tween: Tween<double>(begin: 0.0, end: _isReversed ? -2.5 : 2.5),
            builder: (context, double statementPosition, _) {
              return Transform.translate(
                offset: Offset(0.0, statementPosition),
                child: Text(
                  'quit',
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    decoration: TextDecoration.none,
                    fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 10),
                    fontWeight: FontWeight.bold,
                    color: Utils.getPassedColorFromTheme(),
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Responsive(
        child: Consumer2<OptionsNotifier, EntityNotifier>(builder: (context, _, entityNotifier, __) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('waiting for opponent... roomId: ${Utils.roomId}'),
                buildValidationButton(() {
                  entityNotifier.changeGameEntity(Entity.lobby);
                }),
              ],
            );
          }
        ),
      ),
    );
  }
}