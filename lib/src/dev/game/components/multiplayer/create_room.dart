import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/utils.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({Key? key}) : super(key: key);

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  bool _isReversed = false;
  String? _nameErrorMessage;
  int _nameTextFieldSizeWhenPb = 0;
  double _sliderValue = 0.0;
  double _customThumbPadding = 15.0;
  int _nbOfRounds = 2;

  final TextEditingController _nameController = TextEditingController();

  Future creatRoomInFirebase() async {
    final Random random = Random();
    final int roomId = random.nextInt(999999);

    final docUser =
        FirebaseFirestore.instance.collection('rooms').doc('room-$roomId');
    final json = {
      'roomId': roomId,
      'nbOfRounds': _nbOfRounds,
      'creatorName': _nameController.text,
      'guestName': '',
      'creatorTurn': true,
      'guestTurn': false,
    };
    await docUser.set(json);
  }

  Widget buildValidationButton() {
    return GestureDetector(
      onTap: () => {
        if (_nameController.text.length < 3 || _nameController.text.length > 10)
          {
            _nameErrorMessage = "Please enter a name with 3-10 chars.",
            _nameTextFieldSizeWhenPb = _nameController.text.length,
          }
        else
          {
            creatRoomInFirebase(),
          }
      },
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS),
        height: Utils.TEXT_FIELD_HEIGHT,
        width: MediaQuery.of(context).size.width *
            Utils.ROOM_LOOBY_WIDTH_LIMIT_RATIO /
            2,
        decoration: Utils.buildNeumorphismBox(25.0, 5.0, 5.0, false),
        child: Center(
          child: TweenAnimationBuilder<double>(
              onEnd: () => setState(() {
                    _isReversed = !_isReversed;
                  }),
              duration: const Duration(milliseconds: 250),
              tween: Tween<double>(begin: 0.0, end: _isReversed ? -2.5 : 2.5),
              builder: (context, double statementPosition, _) {
                return Transform.translate(
                  offset: Offset(0.0, statementPosition),
                  child: Text(
                    'click to create!',
                    style: GoogleFonts.bebasNeue(
                      decoration: TextDecoration.none,
                      fontSize: min(
                              min(MediaQuery.of(context).size.width,
                                  MediaQuery.of(context).size.height),
                              500) *
                          10 *
                          2 /
                          392.73,
                      fontWeight: FontWeight.bold,
                      color: Utils.getPassedColorFromTheme(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget buildNameErrorMessage() {
    if (_nameErrorMessage == null ||
        _nameController.text.length != _nameTextFieldSizeWhenPb) {
      if (_nameController.text.length != _nameTextFieldSizeWhenPb) {
        _nameErrorMessage = null;
      }
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.025,
      );
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.025,
      child: Text(
        _nameErrorMessage!,
        style: GoogleFonts.bebasNeue(
          decoration: TextDecoration.none,
          fontSize: min(
                  min(MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height),
                  500) *
              7 *
              2 /
              392.73,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void computeNewPaddingForCustomThumb() {
    if ((_sliderValue - 0.0).abs() < Utils.ZERO_PLUS) {
      _customThumbPadding = 15.0;
      return;
    }
    if ((_sliderValue - 1.0).abs() < Utils.ZERO_PLUS) {
      _customThumbPadding = MediaQuery.of(context).size.width *
              Utils.ROOM_LOOBY_WIDTH_LIMIT_RATIO -
          46.0;
      return;
    }
    _customThumbPadding = 15.0 +
        _sliderValue *
            (MediaQuery.of(context).size.width *
                    Utils.ROOM_LOOBY_WIDTH_LIMIT_RATIO -
                31.0 -
                15.0);
  }

  Widget buildRoundsGauge() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS),
      width: MediaQuery.of(context).size.width *
          Utils.ROOM_LOOBY_WIDTH_LIMIT_RATIO,
      height: Utils.TEXT_FIELD_HEIGHT,
      decoration: Utils.buildNeumorphismBox(25.0, 5.0, 5.0, true),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: _customThumbPadding),
              child: AnimatedContainer(
                duration: const Duration(
                    milliseconds: Utils.THEME_ANIMATION_DURATION_MS),
                height: 31,
                width: 31,
                decoration: Utils.buildNeumorphismBox(25.0, 2.0, 2.0, false),
              ),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 0.0),
                overlayColor: Colors.transparent,
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
                inactiveTickMarkColor: Colors.transparent),
            child: Slider(
              value: _sliderValue,
              onChanged: (newSliderValue) => setState(() {
                _sliderValue = newSliderValue;
                computeNewPaddingForCustomThumb();
                _nbOfRounds = (2 + _sliderValue * 8.0).toInt();
              }),
              divisions: 4,
              inactiveColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNbOfRoundsStatement() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
        child: Text(
          'number of rounds: $_nbOfRounds',
          style: GoogleFonts.bebasNeue(
            decoration: TextDecoration.none,
            fontSize: min(
                    min(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height),
                    500) *
                10 *
                2 /
                392.73,
            fontWeight: FontWeight.bold,
            color: Utils.getPassedColorFromTheme(),
          ),
          textAlign: TextAlign.center,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OptionsNotifier>(builder: (context, _, __) {
      return SizedBox(
        height: MediaQuery.of(context).size.height *
            Utils.ROOM_LOBBY_OPTIONS_HEIGHT_RATIO,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Utils.buildNeumorphicTextField(
                'ENTER YOUR NAME',
                MediaQuery.of(context).size.width *
                    Utils.ROOM_LOOBY_WIDTH_LIMIT_RATIO,
                _nameController),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            buildNameErrorMessage(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            buildRoundsGauge(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            buildNbOfRoundsStatement(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.055),
            buildValidationButton(),
          ],
        ),
      );
    });
  }
}