import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:tightwad/src/utils/colors.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/notifiers/game_handler_notifier.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/database/database.dart';

class LevelPath extends StatefulWidget {
  const LevelPath({Key? key}) : super(key: key);

  @override
  State<LevelPath> createState() => _LevelPathState();
}

class _LevelPathState extends State<LevelPath> {

  double height          = 0.0;
  double width           = 0.0;
  double gamePxSize      = 0.0;
  double outGamePxHeight = 0.0;
  double dashLength      = 0.0;
  double startOfPathLeft = 0.0;
  double endOfPathRight  = 0.0;

  final double pathThickness = 7.0;
  final int nbOfLvlPerLine = 4;
  final int nbOfLine = 3;
  final double endMarginPx = 50.0;

  Color passedColor    = Colors.white;
  Color notPassedColor = Colors.white;
  Color labelColor     = Colors.white;
  Color hideColor      = Colors.white;

  AnimatedContainer buildLvl0(Color labelColor)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: startOfPathLeft + 4 * dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '0',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash1(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: startOfPathLeft + 3 * dashLength,
      ),
      width: dashLength,
      height: pathThickness,
      color: isPassed ? passedColor : notPassedColor,
    );
  }

  AnimatedContainer buildLvl1(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: startOfPathLeft + 3 * dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '1',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash2(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: startOfPathLeft + 2 * dashLength,
      ),
      width: dashLength,
      height: pathThickness,
      color: isPassed ? passedColor : notPassedColor,
    );
  }

  AnimatedContainer buildLvl2(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: startOfPathLeft + 2 * dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '2',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash3(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: startOfPathLeft + dashLength,
      ),
      width: dashLength,
      height: pathThickness,
      color: isPassed ? passedColor : notPassedColor,
    );
  }

  AnimatedContainer buildLvl3(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: startOfPathLeft + dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '3',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash4(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: startOfPathLeft,
      ),
      width: dashLength,
      height: outGamePxHeight / (2 * (nbOfLine + 1)) + pathThickness/2,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
        ),
      ),
    );
  }

  AnimatedContainer buildLvl4(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 / 2 * outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: startOfPathLeft - outGamePxHeight / 14 + pathThickness/2,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '4',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash5(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 / 2 * outGamePxHeight / (nbOfLine + 1),
        left: startOfPathLeft,
      ),
      width: dashLength,
      height: outGamePxHeight / (2 * (nbOfLine + 1)) + pathThickness/2,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
        ),
      ),
    );
  }

  AnimatedContainer buildLvl5(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 2 * outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: startOfPathLeft + dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '5',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildUpperLeftHidder()
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) + pathThickness / 2,
        left: startOfPathLeft + pathThickness,
      ),
      width: dashLength - pathThickness + 1.0,
      height: 2 * outGamePxHeight / (2 * (nbOfLine + 1)) - pathThickness,
      decoration: BoxDecoration(
        color: hideColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
      ),
    );
  }

  AnimatedContainer buildDash6(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 2 * outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: startOfPathLeft + dashLength,
      ),
      width: dashLength,
      height: pathThickness,
      color: isPassed ? passedColor : notPassedColor,
    );
  }

  AnimatedContainer buildLvl6(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 2 * outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: startOfPathLeft + 2 * dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '6',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash7(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 2 * outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: startOfPathLeft + 2 * dashLength,
      ),
      width: dashLength,
      height: pathThickness,
      color: isPassed ? passedColor : notPassedColor,
    );
  }

  AnimatedContainer buildLvl7(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 2 * outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: startOfPathLeft + 3 * dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '7',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash8(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 2 * outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: startOfPathLeft + 3 * dashLength + pathThickness,
      ),
      width: dashLength,
      height: outGamePxHeight / (2 * (nbOfLine + 1)) + pathThickness/2,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20.0),
        ),
      ),
    );
  }

  AnimatedContainer buildLvl8(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 5 / 2 * outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: startOfPathLeft + 4 * dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '8',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash9(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 5 / 2 * outGamePxHeight / (nbOfLine + 1),
        left: startOfPathLeft + 3 * dashLength + pathThickness,
      ),
      width: dashLength,
      height: outGamePxHeight / (2 * (nbOfLine + 1)) + pathThickness/2,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(20.0),
        ),
      ),
    );
  }

  AnimatedContainer buildLvl9(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 * outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: startOfPathLeft + 3 * dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '9',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildUpperRightHidder()
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 2 * outGamePxHeight / (nbOfLine + 1) + pathThickness / 2,
        left: startOfPathLeft + 3 * dashLength - pathThickness / 2 - 1.0,
      ),
      width: dashLength + pathThickness / 2,
      height: 2 * outGamePxHeight / (2 * (nbOfLine + 1)) - pathThickness,
      decoration: BoxDecoration(
        color: hideColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
    );
  }

  AnimatedContainer buildDash10(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 * outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: startOfPathLeft + 2 * dashLength,
      ),
      width: dashLength,
      height: pathThickness,
      color: isPassed ? passedColor : notPassedColor,
    );
  }

  AnimatedContainer buildLvl10(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 * outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: startOfPathLeft + 2 * dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '10',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash11(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 * outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: startOfPathLeft + dashLength,
      ),
      width: dashLength,
      height: pathThickness,
      color: isPassed ? passedColor : notPassedColor,
    );
  }

  AnimatedContainer buildLvl11(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 * outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: startOfPathLeft + dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '11',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash12(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 * outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: startOfPathLeft,
      ),
      width: dashLength,
      height: pathThickness,
      color: isPassed ? passedColor : notPassedColor,
    );
  }

  AnimatedContainer buildLvl12(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 * outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: startOfPathLeft - outGamePxHeight / 14 + pathThickness/2,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '12',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash13U(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 * outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
      ),
      width: startOfPathLeft,
      height: pathThickness,
      color: isPassed ? passedColor : notPassedColor,
    );
  }

  AnimatedContainer buildLvl13(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: endMarginPx + 4 * dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '13',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash13L(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: endMarginPx + 4 * dashLength,
      ),
      width: startOfPathLeft,
      height: pathThickness,
      color: isPassed ? passedColor : notPassedColor,
    );
  }

  AnimatedContainer buildDash14(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: endMarginPx + 3 * dashLength,
      ),
      width: dashLength,
      height: pathThickness,
      color: isPassed ? passedColor : notPassedColor,
    );
  }

  AnimatedContainer buildLvl14(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: endMarginPx + 3 * dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '14',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash15(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: endMarginPx + 2 * dashLength,
      ),
      width: dashLength,
      height: pathThickness,
      color: isPassed ? passedColor : notPassedColor,
    );
  }

  AnimatedContainer buildLvl15(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: endMarginPx + 2 * dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '15',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash16(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: endMarginPx + dashLength,
      ),
      width: dashLength,
      height: pathThickness,
      color: isPassed ? passedColor : notPassedColor,
    );
  }

  AnimatedContainer buildLvl16(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: endMarginPx + dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '16',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash17(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: endMarginPx,
      ),
      width: dashLength,
      height: outGamePxHeight / (2 * (nbOfLine + 1)) + pathThickness/2,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
        ),
      ),
    );
  }

  AnimatedContainer buildLvl17(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 / 2 * outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: endMarginPx - outGamePxHeight / 14 + pathThickness/2,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '17',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash18(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 / 2 * outGamePxHeight / (nbOfLine + 1),
        left: endMarginPx,
      ),
      width: dashLength,
      height: outGamePxHeight / (2 * (nbOfLine + 1)) + pathThickness/2,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
        ),
      ),
    );
  }

  AnimatedContainer buildLvl18(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 2 * outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: endMarginPx + dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '18',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildLowerLeftHidder()
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: outGamePxHeight / (nbOfLine + 1) + pathThickness / 2,
        left: endMarginPx + pathThickness,
      ),
      width: dashLength - pathThickness + 1.0,
      height: 2 * outGamePxHeight / (2 * (nbOfLine + 1)) - pathThickness,
      decoration: BoxDecoration(
        color: hideColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
      ),
    );
  }

  AnimatedContainer buildDash19(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 2 * outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: endMarginPx + dashLength,
      ),
      width: dashLength,
      height: pathThickness,
      color: isPassed ? passedColor : notPassedColor,
    );
  }

  AnimatedContainer buildLvl19(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 2 * outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: endMarginPx + 2 * dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '19',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash20(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 2 * outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: endMarginPx + 2 * dashLength,
      ),
      width: dashLength,
      height: pathThickness,
      color: isPassed ? passedColor : notPassedColor,
    );
  }

  AnimatedContainer buildLvl20(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 2 * outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: endMarginPx + 3 * dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '20',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash21(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 2 * outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: endMarginPx + 3 * dashLength + pathThickness,
      ),
      width: dashLength,
      height: outGamePxHeight / (2 * (nbOfLine + 1)) + pathThickness/2,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20.0),
        ),
      ),
    );
  }

  AnimatedContainer buildLvl21(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 5 / 2 * outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: endMarginPx + 4 * dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '21',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash22(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 5 / 2 * outGamePxHeight / (nbOfLine + 1),
        left: endMarginPx + 3 * dashLength + pathThickness,
      ),
      width: dashLength,
      height: outGamePxHeight / (2 * (nbOfLine + 1)) + pathThickness/2,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(20.0),
        ),
      ),
    );
  }

  AnimatedContainer buildLvl22(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 * outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: endMarginPx + 3 * dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '22',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildLowerRightHidder()
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 2 * outGamePxHeight / (nbOfLine + 1) + pathThickness / 2,
        left: endMarginPx + 3 * dashLength - 1.0 + pathThickness,
      ),
      width: dashLength - pathThickness + 1.0,
      height: 2 * outGamePxHeight / (2 * (nbOfLine + 1)) - pathThickness,
      decoration: BoxDecoration(
        color: hideColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
    );
  }

  AnimatedContainer buildDash23(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 * outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: endMarginPx + 2 * dashLength,
      ),
      width: dashLength,
      height: pathThickness,
      color: isPassed ? passedColor : notPassedColor,
    );
  }

  AnimatedContainer buildLvl23(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 * outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: endMarginPx + 2 * dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '23',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash24(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 * outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: endMarginPx + dashLength,
      ),
      width: dashLength,
      height: pathThickness,
      color: isPassed ? passedColor : notPassedColor,
    );
  }

  AnimatedContainer buildLvl24(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 * outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: endMarginPx + dashLength - outGamePxHeight / 14,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '24',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDash25(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 * outGamePxHeight / (nbOfLine + 1) - pathThickness/2,
        left: endMarginPx,
      ),
      width: dashLength,
      height: pathThickness,
      color: isPassed ? passedColor : notPassedColor,
    );
  }

  AnimatedContainer buildLvl25(bool isPassed)
  {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(
        top: 3 * outGamePxHeight / (nbOfLine + 1) - outGamePxHeight / 14,
        left: endMarginPx - outGamePxHeight / 14 + pathThickness/2,
      ),
      width: outGamePxHeight / 7,
      height: outGamePxHeight / 7,
      decoration: BoxDecoration(
        color: isPassed ? passedColor : notPassedColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Center(
        child: Text(
          '25',
          style: GoogleFonts.inter(
            decoration: TextDecoration.none,
            fontSize: outGamePxHeight / 12,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    height          = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;
    width           = MediaQuery.of(context).size.width;
    gamePxSize      = min(min(width, height) / 1, height / 1.7);
    outGamePxHeight = (height - gamePxSize) / 2;

    startOfPathLeft = gamePxSize / 3.3 + 10;
    endOfPathRight  = width - endMarginPx;
    
    dashLength = (endOfPathRight - startOfPathLeft) / nbOfLvlPerLine;

    return Consumer2<GameHandlerNotifier, OptionsNotifier>(
      builder: (context, gameHandlerNotifier, optionsNotifier, _) {

        hideColor      = Database.getThemeSettingLight() ? ThemeColors.background.getLightColor : ThemeColors.background.getDarkColor;
        labelColor     = Database.getThemeSettingLight() ? ThemeColors.background.getDarkColor  : ThemeColors.background.getLightColor;
        passedColor    = Colors.green;
        notPassedColor = Database.getThemeSettingLight() ? Colors.white54 : Colors.black12;

        return SafeArea(

          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Stack(
                    children: [
                      buildDash1   (gameHandlerNotifier.getLvl > 1),
                      buildDash2   (gameHandlerNotifier.getLvl > 2),
                      buildDash3   (gameHandlerNotifier.getLvl > 3),
                      buildDash4   (gameHandlerNotifier.getLvl > 4),
                      buildDash5   (gameHandlerNotifier.getLvl > 5),
                      buildDash6   (gameHandlerNotifier.getLvl > 6),
                      buildDash7   (gameHandlerNotifier.getLvl > 7),
                      buildDash8   (gameHandlerNotifier.getLvl > 8),
                      buildDash9   (gameHandlerNotifier.getLvl > 9),
                      buildDash10  (gameHandlerNotifier.getLvl > 10),
                      buildDash11  (gameHandlerNotifier.getLvl > 11),
                      buildDash12  (gameHandlerNotifier.getLvl > 12),
                      buildDash13U (gameHandlerNotifier.getLvl > 13),
                          
                      buildUpperLeftHidder (),
                      buildUpperRightHidder(),
                          
                      buildLvl0  (labelColor),
                      buildLvl1  (gameHandlerNotifier.getLvl > 1),
                      buildLvl2  (gameHandlerNotifier.getLvl > 2),
                      buildLvl3  (gameHandlerNotifier.getLvl > 3),
                      buildLvl4  (gameHandlerNotifier.getLvl > 4),
                      buildLvl5  (gameHandlerNotifier.getLvl > 5),
                      buildLvl6  (gameHandlerNotifier.getLvl > 6),
                      buildLvl7  (gameHandlerNotifier.getLvl > 7),
                      buildLvl8  (gameHandlerNotifier.getLvl > 8),
                      buildLvl9  (gameHandlerNotifier.getLvl > 9),
                      buildLvl10 (gameHandlerNotifier.getLvl > 10),
                      buildLvl11 (gameHandlerNotifier.getLvl > 11),
                      buildLvl12 (gameHandlerNotifier.getLvl > 12),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      buildDash13L(gameHandlerNotifier.getLvl > 13),
                      buildDash14 (gameHandlerNotifier.getLvl > 14),
                      buildDash15 (gameHandlerNotifier.getLvl > 15),
                      buildDash16 (gameHandlerNotifier.getLvl > 16),
                      buildDash17 (gameHandlerNotifier.getLvl > 17),
                      buildDash18 (gameHandlerNotifier.getLvl > 18),
                      buildDash19 (gameHandlerNotifier.getLvl > 19),
                      buildDash20 (gameHandlerNotifier.getLvl > 20),
                      buildDash21 (gameHandlerNotifier.getLvl > 21),
                      buildDash22 (gameHandlerNotifier.getLvl > 22),
                      buildDash23 (gameHandlerNotifier.getLvl > 23),
                      buildDash24 (gameHandlerNotifier.getLvl > 24),
                      buildDash25 (gameHandlerNotifier.getGameStatus == GameStatus.win && gameHandlerNotifier.getLvl > 24 ||
                                   gameHandlerNotifier.getGameStatus == GameStatus.finish),
                      buildLowerLeftHidder (),
                      buildLowerRightHidder(),
                      buildLvl13(gameHandlerNotifier.getLvl > 13),
                      buildLvl14(gameHandlerNotifier.getLvl > 14),
                      buildLvl15(gameHandlerNotifier.getLvl > 15),
                      buildLvl16(gameHandlerNotifier.getLvl > 16),
                      buildLvl17(gameHandlerNotifier.getLvl > 17),
                      buildLvl18(gameHandlerNotifier.getLvl > 18),
                      buildLvl19(gameHandlerNotifier.getLvl > 19),
                      buildLvl20(gameHandlerNotifier.getLvl > 20),
                      buildLvl21(gameHandlerNotifier.getLvl > 21),
                      buildLvl22(gameHandlerNotifier.getLvl > 22),
                      buildLvl23(gameHandlerNotifier.getLvl > 23),
                      buildLvl24(gameHandlerNotifier.getLvl > 24),
                      buildLvl25(gameHandlerNotifier.getGameStatus == GameStatus.win && gameHandlerNotifier.getLvl > 24 ||
                                 gameHandlerNotifier.getGameStatus == GameStatus.finish),
                    ],
                  ),
                
                SizedBox(
                  height: outGamePxHeight / (nbOfLine + 2) - pathThickness / 2,
                ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}