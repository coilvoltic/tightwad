import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';
import 'package:tightwad/src/utils/colors.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  bool reversed = false;
  int nbOfBouncing = 0;

  @override
  Widget build(BuildContext context) {

    EntityNotifier notifier = Provider.of<EntityNotifier>(context);

    return Consumer<EntityNotifier>(

      builder: (context, entityNotifier, _) {

        return Stack(
          children: [
            Container(
              color: ThemeColors.background.getLightColor,
            ),
            SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('WELCOME TO',
                          style: GoogleFonts.bebasNeue(
                            decoration: TextDecoration.none,
                            fontSize: min(min(MediaQuery.of(context).size.width,
                                          MediaQuery.of(context).size.height),
                                      500) * 40 * 2 / 392.73,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.background.getDarkColor,
                          ),
                        ),
                        Text('tightwad!',
                          style: GoogleFonts.parisienne(
                            decoration: TextDecoration.none,
                            fontSize: min(min(MediaQuery.of(context).size.width,
                                          MediaQuery.of(context).size.height),
                                      500) * 30 * 2 / 392.73,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.background.getDarkColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 300),
                    tween: Tween<double>(begin: 0.0, end: reversed ? -3.0 : 3.0),
                    builder: (context, double statementPosition, _) {
                      return Visibility(
                        visible: nbOfBouncing >= 8,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.only(
                              bottom: 60.0,
                            ),
                            child: Transform.translate(
                              offset: Offset(0.0, statementPosition),
                              child: Text('TAP TO START TUTORIAL',
                                style: GoogleFonts.bebasNeue(
                                  decoration: TextDecoration.none,
                                  fontSize: min(min(MediaQuery.of(context).size.width,
                                                MediaQuery.of(context).size.height),
                                            500) * 10 * 2 / 392.73,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeColors.background.getDarkColor,
                                ),
                              ),
                            ),
                          )
                        ),
                      );
                    },
                    onEnd: () => setState(() {
                      reversed = !reversed;
                      if (nbOfBouncing < 8)
                      {
                        nbOfBouncing++;
                      }
                    }),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: nbOfBouncing >= 8,
              child: Center(
                child: SizedBox.expand(
                  child: TextButton(
                    onPressed: () => notifier.changeTutorialPhase(),
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

      },

    );
  }
}
