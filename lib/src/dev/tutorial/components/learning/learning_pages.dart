import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';

import 'package:tightwad/src/utils/colors.dart';
import 'package:tightwad/src/dev/tutorial/components/learning/utils/mock_map.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/utils.dart';

class LearningPages extends StatefulWidget {
  const LearningPages({Key? key}) : super(key: key);

  @override
  State<LearningPages> createState() => _LearningPagesState();
}

class _LearningPagesState extends State<LearningPages> {
  final pageViewController = PageController();
  bool isLastPage = false;
  bool reversed = false;

  final double bottomSheetHeight = 80.0;

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  Widget buildPage1Description() {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: const EdgeInsets.only(
            top: 40.0,
          ),
          child: GlowText(
          'YOU START THE GAME\nBY PICKING ONE ELEMENT',
          blurRadius: Utils.shouldGlow() ? Utils.GLOWING_VALUE : 0.0,
          glowColor: Utils.shouldGlow()
                ? Utils.getPassedColorFromTheme()
                : Colors.transparent,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'BebasNeue',
            decoration: TextDecoration.none,
            fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 15),
            fontWeight: FontWeight.bold,
            color: Utils.getPassedColorFromTheme(),
          ),
        ),
      ),
    ));
  }

  Widget buildPage1() {
    return Stack(
      children: [
        buildPage1Description(),
        const MockMap(pageIndex: 1),
      ],
    );
  }

  Widget buildPage2Description() {
    return SafeArea(
        child: Container(
      padding: const EdgeInsets.only(
        top: 40.0,
        bottom: 80.0,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GlowText(
              'YOU CAN CHOOSE ONLY ONE\nELEMENT PER ROW AND COLUMN',
              blurRadius: Utils.shouldGlow() ? Utils.GLOWING_VALUE : 0.0,
              glowColor: Utils.shouldGlow()
                    ? Utils.getPassedColorFromTheme()
                    : Colors.transparent,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BebasNeue',
                decoration: TextDecoration.none,
                fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 15),
                fontWeight: FontWeight.bold,
                color: Utils.getPassedColorFromTheme(),
              ),
            ),
            GlowText(
              'SO THERE WILL BE BLOCKED CELLS',
              blurRadius: Utils.shouldGlow() ? Utils.GLOWING_VALUE : 0.0,
              glowColor: Utils.shouldGlow()
                    ? Utils.getPassedColorFromTheme()
                    : Colors.transparent,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BebasNeue',
                decoration: TextDecoration.none,
                fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 15),
                fontWeight: FontWeight.bold,
                color: Utils.getPassedColorFromTheme(),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget buildPage2() {
    return Stack(
      children: [
        buildPage2Description(),
        const MockMap(pageIndex: 2),
      ],
    );
  }

  Widget buildPage3Description() {
    return SafeArea(
        child: Container(
      padding: const EdgeInsets.only(
        top: 40.0,
        bottom: 80.0,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GlowText(
              'LOOK AT SOME COMBINATIONS\nYOU COULD OBTAIN AT THE END',
              blurRadius: Utils.shouldGlow() ? Utils.GLOWING_VALUE : 0.0,
              glowColor: Utils.shouldGlow()
                    ? Utils.getPassedColorFromTheme()
                    : Colors.transparent,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BebasNeue',
                decoration: TextDecoration.none,
                fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 15),
                fontWeight: FontWeight.bold,
                color: Utils.getPassedColorFromTheme(),
              ),
            ),
            GlowText(
              'TRY TO HAVE IT AT SMALL AS POSSIBLE',
              blurRadius: Utils.shouldGlow() ? Utils.GLOWING_VALUE : 0.0,
              glowColor: Utils.shouldGlow()
                    ? Utils.getPassedColorFromTheme()
                    : Colors.transparent,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BebasNeue',
                decoration: TextDecoration.none,
                fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 15),
                fontWeight: FontWeight.bold,
                color: Utils.getPassedColorFromTheme(),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget buildPage3() {
    return Stack(
      children: [
        buildPage3Description(),
        const MockMap(pageIndex: 3),
      ],
    );
  }

  Widget buildPage4Description() {
    return SafeArea(
        child: Container(
      padding: const EdgeInsets.only(
        top: 40.0,
        bottom: 80.0,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GlowText(
              'YOU AND AN ALGORITHM WILL\nCHOOSE AN ELEMENT ONE BY ONE',
              blurRadius: Utils.shouldGlow() ? Utils.GLOWING_VALUE : 0.0,
              glowColor: Utils.shouldGlow()
                    ? Utils.getPassedColorFromTheme()
                    : Colors.transparent,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BebasNeue',
                decoration: TextDecoration.none,
                fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 15),
                fontWeight: FontWeight.bold,
                color: Utils.getPassedColorFromTheme(),
              ),
            ),
            GlowText(
              'AT THE END, SMALLEST SUM WINS.',
              blurRadius: Utils.shouldGlow() ? Utils.GLOWING_VALUE : 0.0,
              glowColor: Utils.shouldGlow()
                    ? Utils.getPassedColorFromTheme()
                    : Colors.transparent,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BebasNeue',
                decoration: TextDecoration.none,
                fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 15),
                fontWeight: FontWeight.bold,
                color: Utils.getPassedColorFromTheme(),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget buildPage4() {
    return Stack(
      children: [
        buildPage4Description(),
        const MockMap(pageIndex: 4),
      ],
    );
  }

  Widget buildPage5() {
    EntityNotifier notifier = Provider.of<EntityNotifier>(context);

    return Stack(
      children: [
        Container(
            color: Utils.getBackgroundColorFromTheme(),
            child: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: GlowText(
                      'GOT IT?',
                      blurRadius: Utils.shouldGlow() ? Utils.GLOWING_VALUE : 0.0,
                      glowColor: Utils.shouldGlow()
                            ? Utils.getPassedColorFromTheme()
                            : Colors.transparent,
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        decoration: TextDecoration.none,
                        fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 60),
                        fontWeight: FontWeight.bold,
                        color: Utils.getPassedColorFromTheme(),
                      ),
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 300),
                    tween:
                        Tween<double>(begin: 0.0, end: reversed ? -3.0 : 3.0),
                    builder: (context, double statementPosition, _) {
                      return Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.only(
                              bottom: 150.0,
                            ),
                            child: Transform.translate(
                              offset: Offset(0.0, statementPosition),
                              child: GlowText(
                                'TAP TO PLAY!',
                                blurRadius: Utils.shouldGlow() ? Utils.GLOWING_VALUE : 0.0,
                                glowColor: Utils.shouldGlow()
                                      ? Utils.getPassedColorFromTheme()
                                      : Colors.transparent,
                                style: TextStyle(
                                  fontFamily: 'BebasNeue',
                                  decoration: TextDecoration.none,
                                  fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 15),
                                  fontWeight: FontWeight.bold,
                                  color: Utils.getPassedColorFromTheme(),
                                ),
                              ),
                            ),
                          ));
                    },
                    onEnd: () => setState(() {
                      reversed = !reversed;
                    }),
                  ),
                ],
              ),
            )),
        Center(
          child: SizedBox.expand(
            child: TextButton(
              onPressed: () =>
                  notifier.changeGameEntity(Entity.singleplayergame),
              style: const ButtonStyle(
                splashFactory: NoSplash.splashFactory,
              ),
              child: const Text(""),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPlayButton() {
    return TweenAnimationBuilder(
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 0.0, end: reversed ? -3.0 : 3.0),
        onEnd: () => {
              setState(() {
                reversed = !reversed;
              }),
            },
        builder: (context, double statementPosition, child) {
          return Transform.translate(
            offset: Offset(0.0, statementPosition),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                minimumSize: Size.fromHeight(bottomSheetHeight),
              ),
              child: GlowText(
                'CLICK TO PLAY!',
                blurRadius: Utils.shouldGlow() ? Utils.GLOWING_VALUE : 0.0,
                glowColor: Utils.shouldGlow()
                      ? Utils.getPassedColorFromTheme()
                      : Colors.transparent,
                style: TextStyle(
                  fontFamily: 'Righteous',
                  decoration: TextDecoration.none,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Utils.getPassedColorFromTheme(),
                ),
              ),
            ),
          );
        });
  }

  SmoothPageIndicator buildSmoothPageIndicator() {
    return SmoothPageIndicator(
      controller: pageViewController,
      count: 5,
      effect: WormEffect(
        spacing: 15,
        dotColor: Colors.black12,
        activeDotColor: Utils.getPassedColorFromTheme(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Utils.getBackgroundColorFromTheme(),
          ),
          PageView(
            onPageChanged: (index) => {
              setState(() => isLastPage = index == 4),
            },
            controller: pageViewController,
            children: [
              buildPage1(),
              buildPage2(),
              buildPage3(),
              buildPage4(),
              buildPage5(),
            ],
          ),
        ],
      ),
      bottomSheet: SafeArea(
        child: SizedBox(
          height: bottomSheetHeight,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: isLastPage
                ? Container(color: Utils.getBackgroundColorFromTheme())
                : buildSmoothPageIndicator(),
          ),
        ),
      ),
    );
  }
}
