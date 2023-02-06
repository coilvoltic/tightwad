import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/nothing.dart';
import 'package:tightwad/src/utils/utils.dart';

class LevelPath2 extends StatefulWidget {
  const LevelPath2({super.key});

  @override
  State<LevelPath2> createState() => _LevelPath2State();
}

class _LevelPath2State extends State<LevelPath2> {

  double _height = 0.0;
  double _width = 0.0;
  double _containerHeight = 0.0;
  double _pathThickness = 0.0;
  double _labelContainerSize = 0.0;
  double _labelSize = 0.0;
  int _nbOfRounds = 0;
  final double _widthRatioLimit = 0.75;

  Widget buildLabelChild(final int index, final bool isPassed, final RoundStatus roundStatus) {
    if (roundStatus == RoundStatus.won) {
      return Center(
        child: Icon(
          Icons.check,
          color: isPassed ? Utils.getLabelPassedColorFromTheme() : Utils.getLabelNotPassedColorFromTheme(),
          size: _labelSize,
        ),
      );
    } else if (roundStatus == RoundStatus.lost) {
      return Center(
        child: Icon(
          Icons.close,
          color: isPassed ? Utils.getLabelPassedColorFromTheme() : Utils.getLabelNotPassedColorFromTheme(),
          size: _labelSize,
        ),
      );
    } else if (roundStatus == RoundStatus.draw) {
      return Center(
        child: Text(
          '=',
          style: TextStyle(
            fontFamily: 'Inter',
            decoration: TextDecoration.none,
            fontSize: _labelSize,
            fontWeight: FontWeight.bold,
            color: isPassed ? Utils.getLabelPassedColorFromTheme() : Utils.getLabelNotPassedColorFromTheme(),
          ),
        ),
      );
    } else {
      return Center(
        child: Text(
          '${index + 1}',
          style: TextStyle(
            fontFamily: 'Inter',
            decoration: TextDecoration.none,
            fontSize: _labelSize,
            fontWeight: FontWeight.bold,
            color: isPassed ? Utils.getLabelPassedColorFromTheme() : Utils.getLabelNotPassedColorFromTheme(),
          ),
        ),
      );
    }

  }

  AnimatedContainer buildSegmentFirstLine(final int index, bool isPassed) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(left: index * _width * _widthRatioLimit / (_nbOfRounds / 2 + 1),
                              top: 1 * _containerHeight / 3 - _pathThickness / 2),
      height: _pathThickness,
      width: _width * _widthRatioLimit / (_nbOfRounds / 2 + 1),
      color: isPassed ? Utils.getPassedColorFromTheme() : Utils.getNotPassedColorFromTheme(),
    );
  }

  AnimatedContainer buildLabelFirstLine(final int index, bool isPassed, RoundStatus roundStatus) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(left: (index + 1) * _width * _widthRatioLimit / (_nbOfRounds / 2 + 1) - _labelContainerSize / 2,
                              top: 1 * _containerHeight / 3 - _labelContainerSize / 2),
      height: _labelContainerSize,
      width: _labelContainerSize,
      decoration: BoxDecoration(
        color: isPassed ? Utils.getPassedColorFromTheme() : Utils.getNotPassedColorFromTheme(),
        borderRadius: BorderRadius.all(Radius.circular(_labelContainerSize))
      ),
      child: buildLabelChild(index, isPassed, roundStatus),
    );
  }

  AnimatedContainer buildSegmentSecondLine(final int index, bool isPassed) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(left: (_nbOfRounds - index - 1) * _width * _widthRatioLimit / (_nbOfRounds / 2 + 1),
                              top: 2 * _containerHeight / 3 - _pathThickness / 2),
      height: _pathThickness,
      width: _width * _widthRatioLimit / (_nbOfRounds / 2 + 1),
        color: isPassed ? Utils.getPassedColorFromTheme() : Utils.getNotPassedColorFromTheme(),
    );
  }

  AnimatedContainer buildLabelSecondLine(final int index, bool isPassed, RoundStatus roundStatus) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(left: (_nbOfRounds - index) * _width * _widthRatioLimit / (_nbOfRounds / 2 + 1) - _labelContainerSize / 2,
                              top: 2 * _containerHeight / 3 - _labelContainerSize / 2),
      height: _labelContainerSize,
      width: _labelContainerSize,
      decoration: BoxDecoration(
        color: isPassed ? Utils.getPassedColorFromTheme() : Utils.getNotPassedColorFromTheme(),
        borderRadius: BorderRadius.all(Radius.circular(_labelContainerSize))
      ),
      child: buildLabelChild(index, isPassed, roundStatus),
    );
  }

  Stack buildLinkLine(final bool isPassed) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: EdgeInsets.only(left: _nbOfRounds / 2 * _width * _widthRatioLimit / (_nbOfRounds / 2 + 1),
                                  top: 1 * _containerHeight / 3 - _pathThickness / 2),
          height: 1 * _containerHeight / 3 + _pathThickness,
          width: _width * _widthRatioLimit / (_nbOfRounds / 2 + 1),
          decoration: BoxDecoration(
            color: isPassed ? Utils.getPassedColorFromTheme() : Utils.getNotPassedColorFromTheme(),
            borderRadius: BorderRadius.only(topRight: Radius.circular(_labelContainerSize * 4), bottomRight: Radius.circular(_labelContainerSize * 4))
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: EdgeInsets.only(left: _nbOfRounds / 2 * _width * _widthRatioLimit / (_nbOfRounds / 2 + 1) - _pathThickness,
                                  top: 1 * _containerHeight / 3 + _pathThickness / 2),
          height: 1 * _containerHeight / 3 - _pathThickness,
          width: _width * _widthRatioLimit / (_nbOfRounds / 2 + 1),
          decoration: BoxDecoration(
            color: Utils.getBackgroundColorFromTheme(),
            borderRadius: BorderRadius.only(topRight: Radius.circular(_labelContainerSize * 4), bottomRight: Radius.circular(_labelContainerSize * 4))
          ),
        ),
      ],
    );
  }

  Widget buildLevelPath(final MultiPlayerNotifier mpNotifier) {
    List<RoundStatus> roundStatuses = MultiPlayerNotifier.multiPlayerStatus == MultiPlayerStatus.creator ? mpNotifier.getCreatorRoundStatus : mpNotifier.getGuestRoundStatus;
    return Stack(
      children: [
        buildLinkLine(mpNotifier.getCurrentRound > _nbOfRounds / 2),
        for (int i = 0; i < _nbOfRounds; i++)
          (i+1) <= _nbOfRounds / 2 ? buildSegmentFirstLine(i, i < mpNotifier.getCurrentRound) : buildSegmentSecondLine(i, (i + 1) < mpNotifier.getCurrentRound),
        for (int i = 0; i < _nbOfRounds; i++)
          (i+1) <= _nbOfRounds / 2 ? buildLabelFirstLine(i, i < mpNotifier.getCurrentRound, roundStatuses[i]) : buildLabelSecondLine(i, i < mpNotifier.getCurrentRound, roundStatuses[i]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width  = MediaQuery.of(context).size.width;
    _containerHeight = (_height - min(min(_width, _height) / 1, _height / 1.7)) / 2;
    _pathThickness = _containerHeight * 9.0 / 225.0;
    _labelContainerSize = _containerHeight * 28.0 / 225.0;
    _labelSize = _containerHeight * 18.0 / 225.0;

    return Consumer2<OptionsNotifier, MultiPlayerNotifier>(builder: (context, _, mpNotifier, __) {
      if (MultiPlayerNotifier.shouldSessionBeInitialized) {
        return const Nothing();
      }
      _nbOfRounds = mpNotifier.getNbOfRounds;
        return Container(
          margin: EdgeInsets.only(top: _height - _containerHeight),
          height: _containerHeight,
          child: buildLevelPath(mpNotifier),
      );
    });
  }
}
