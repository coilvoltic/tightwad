import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';

import 'package:tightwad/src/utils/colors.dart';
import 'package:tightwad/src/dev/tutorial/components/learning/utils/mock_map.dart';
import 'package:tightwad/src/utils/common_enums.dart';

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

  Widget buildPage1Description()
  {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: const EdgeInsets.only(
            top: 40.0,
          ),
          child: Text('YOU START THE GAME\nBY PICKING ONE ELEMENT',
            textAlign: TextAlign.center,
            style: GoogleFonts.bebasNeue(
              decoration: TextDecoration.none,
              fontSize: min(min(MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height),
                        500) * 15 * 2 / 392.73,
              fontWeight: FontWeight.bold,
              color: ThemeColors.background.getDarkColor,
            ),
          ),
        ),
      )
    );
  }

  Widget buildPage1()
  {
    return Stack(
      children: [
        buildPage1Description(),
        const MockMap(pageIndex: 1),
      ],
    );
  }

  Widget buildPage2Description()
  {
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
              Text('YOU CAN CHOOSE ONLY ONE\nELEMENT PER ROW AND COLUMN',
                textAlign: TextAlign.center,
                style: GoogleFonts.bebasNeue(
                  decoration: TextDecoration.none,
                  fontSize: min(min(MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height),
                            500) * 15 * 2 / 392.73,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.background.getDarkColor,
                ),
              ),
              Text('SO THERE WILL BE BLOCKED CELLS',
                textAlign: TextAlign.center,
                style: GoogleFonts.bebasNeue(
                  decoration: TextDecoration.none,
                  fontSize: min(min(MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height),
                            500) * 15 * 2 / 392.73,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.background.getDarkColor,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget buildPage2()
  {
    return Stack(
      children: [
        buildPage2Description(),
        const MockMap(pageIndex: 2),
      ],
    );
  }

  Widget buildPage3Description()
  {
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
              Text('LOOK AT SOME COMBINATIONS\nYOU COULD OBTAIN AT THE END',
                textAlign: TextAlign.center,
                style: GoogleFonts.bebasNeue(
                  decoration: TextDecoration.none,
                  fontSize: min(min(MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height),
                            500) * 15 * 2 / 392.73,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.background.getDarkColor,
                ),
              ),
              Text('TRY TO HAVE IT AT SMALL AS POSSIBLE',
                textAlign: TextAlign.center,
                style: GoogleFonts.bebasNeue(
                  decoration: TextDecoration.none,
                  fontSize: min(min(MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height),
                            500) * 15 * 2 / 392.73,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.background.getDarkColor,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget buildPage3()
  {
    return Stack(
      children: [
        buildPage3Description(),
        const MockMap(pageIndex: 3),
      ],
    );
  }

  Widget buildPage4Description()
  {
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
              Text('YOU AND AN ALGORITHM WILL\nCHOOSE AN ELEMENT ONE BY ONE',
                textAlign: TextAlign.center,
                style: GoogleFonts.bebasNeue(
                  decoration: TextDecoration.none,
                  fontSize: min(min(MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height),
                            500) * 15 * 2 / 392.73,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.background.getDarkColor,
                ),
              ),
              Text('AT THE END, SMALLEST SUM WINS.',
                textAlign: TextAlign.center,
                style: GoogleFonts.bebasNeue(
                  decoration: TextDecoration.none,
                  fontSize: min(min(MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height),
                            500) * 15 * 2 / 392.73,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.background.getDarkColor,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget buildPage4()
  {
    return Stack(
      children: [
        buildPage4Description(),
        const MockMap(pageIndex: 4),
      ],
    );
  }

  Widget buildPage5()
  {
    
    EntityNotifier notifier = Provider.of<EntityNotifier>(context);

    return Stack(
      children: [
        Container(
          color: ThemeColors.background.getLightColor,
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Text('GOT IT?',
                    style: GoogleFonts.bebasNeue(
                      decoration: TextDecoration.none,
                      fontSize: min(min(MediaQuery.of(context).size.width,
                                    MediaQuery.of(context).size.height),
                                500) * 60 * 2 / 392.73,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.background.getDarkColor,
                    ),
                  ),
                ),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 300),
                  tween: Tween<double>(begin: 0.0, end: reversed ? -3.0 : 3.0),
                  builder: (context, double statementPosition, _) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.only(
                          bottom: 150.0,
                        ),
                        child: Transform.translate(
                          offset: Offset(0.0, statementPosition),
                          child: Text('TAP TO PLAY!',
                            style: GoogleFonts.bebasNeue(
                              decoration: TextDecoration.none,
                              fontSize: min(min(MediaQuery.of(context).size.width,
                                            MediaQuery.of(context).size.height),
                                        500) * 15 * 2 / 392.73,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.background.getDarkColor,
                            ),
                          ),
                        ),
                      )
                    );
                  },
                  onEnd: () => setState(() {
                    reversed = !reversed;
                  }),
                ),
              ],
            ),
          )
        ),
        Center(
          child: SizedBox.expand(
            child: TextButton(
              onPressed: () => notifier.changeGameEntity(Entity.singleplayer),
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


  Widget buildPlayButton()
  {
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
            child: Text('CLICK TO PLAY!',
              style: GoogleFonts.righteous(
                decoration: TextDecoration.none,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: ThemeColors.background.getDarkColor,
              ),
            ),
          ),
        );
      }
    );
  }

  SmoothPageIndicator buildSmoothPageIndicator()
  {
    return SmoothPageIndicator(
      controller: pageViewController,
      count: 5,
      effect: WormEffect(
        spacing: 15,
        dotColor: Colors.black12,
        activeDotColor: ThemeColors.background.getDarkColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: ThemeColors.background.getLightColor,
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
            child: isLastPage ? Container(color: ThemeColors.background.getLightColor) : buildSmoothPageIndicator(),
          ),
        ),
      ),
    );
  }
}