import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/utils.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key, required this.destination, this.entityDestination})
      : super(key: key);

  final String destination;
  final Entity? entityDestination;

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool _isReversed = false;
  int _nbOfBouncing = 0;

  @override
  Widget build(BuildContext context) {
    EntityNotifier notifier =
        Provider.of<EntityNotifier>(context, listen: false);

    return Stack(
      children: [
        Container(
          color: Utils.getBackgroundColorFromTheme(),
        ),
        SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'WELCOME TO',
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        decoration: TextDecoration.none,
                        fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 40),
                        fontWeight: FontWeight.bold,
                        color: Utils.getPassedColorFromTheme(),
                      ),
                    ),
                    GlowText(
                      widget.destination,
                      blurRadius: Utils.shouldGlow() ? 2.5 : 0.0,
                      glowColor: Utils.shouldGlow()
                          ? Utils.getPassedColorFromTheme()
                          : Colors.transparent,
                      style: TextStyle(
                        fontFamily: 'Parisienne',
                        decoration: TextDecoration.none,
                        fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 30),
                        fontWeight: FontWeight.bold,
                        color: Utils.getPassedColorFromTheme(),
                      ),
                    ),
                  ],
                ),
              ),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween<double>(begin: 0.0, end: _isReversed ? -3.0 : 3.0),
                builder: (context, double statementPosition, _) {
                  return Visibility(
                    visible: _nbOfBouncing >= 8,
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.only(
                            bottom: 60.0,
                          ),
                          child: Transform.translate(
                            offset: Offset(0.0, statementPosition),
                            child: Text(
                              Database.getGameEntity() ==
                                      Utils.TUTORIAL_ENTITY_INDEX
                                  ? 'TAP TO START TUTORIAL'
                                  : 'TAP TO PLAY',
                              style: TextStyle(
                                fontFamily: 'BebasNeue',
                                decoration: TextDecoration.none,
                                fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 10),
                                fontWeight: FontWeight.bold,
                                color: Utils.getPassedColorFromTheme(),
                              ),
                            ),
                          ),
                        )),
                  );
                },
                onEnd: () => setState(() {
                  _isReversed = !_isReversed;
                  if (_nbOfBouncing < 8) {
                    _nbOfBouncing++;
                  }
                }),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _nbOfBouncing >= 8,
          child: Center(
            child: SizedBox.expand(
              child: TextButton(
                onPressed: () => {
                  if (Database.getGameEntity() == Utils.TUTORIAL_ENTITY_INDEX)
                    {
                      notifier.changeTutorialPhase(),
                    }
                  else
                    {
                      notifier.changeGameEntity(widget.entityDestination!),
                    }
                },
                style: const ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                ),
                child: const Text(""),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
