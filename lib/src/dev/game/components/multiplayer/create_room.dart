import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/dev/game/components/multiplayer/validation_button.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/utils.dart';


class CreateRoom extends StatefulWidget {
  const CreateRoom({Key? key}) : super(key: key);

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {

  String? _nameErrorMessage;
  double _sliderValue = 0.0;
  double _customThumbPadding = 15.0;
  int _nbOfRounds = 2;

  final TextEditingController _nameController = TextEditingController();

  Widget buildNameErrorMessage() {
    if (_nameErrorMessage == null) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.025,
      );
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.025,
      child: Text(
        _nameErrorMessage!,
        style: TextStyle(
          fontFamily: 'BebasNeue',
          decoration: TextDecoration.none,
          fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 7),
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
      _customThumbPadding = MediaQuery.of(context).size.width * Utils.ROOM_LOOBY_WIDTH_LIMIT_RATIO - 46.0;
      return;
    }
    _customThumbPadding = 15.0 + _sliderValue *
                          (MediaQuery.of(context).size.width * Utils.ROOM_LOOBY_WIDTH_LIMIT_RATIO - 31.0 - 15.0);
  }

  Widget buildRoundsGauge() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS),
      width: MediaQuery.of(context).size.width *
          Utils.ROOM_LOOBY_WIDTH_LIMIT_RATIO,
      height: Utils.TEXT_FIELD_HEIGHT,
      decoration: Utils.buildNeumorphismBox(15.0, 5.0, 3.5, true),
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
                decoration: Utils.buildNeumorphismBox(25.0, 4.0, 2.0, false),
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
        style: TextStyle(
          fontFamily: 'BebasNeue',
          decoration: TextDecoration.none,
          fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 10),
          fontWeight: FontWeight.bold,
          color: Utils.getPassedColorFromTheme(),
        ),
        textAlign: TextAlign.center,
      ));
  }

  @override
  Widget build(BuildContext context) {
    MultiPlayerNotifier mpNotifier = Provider.of<MultiPlayerNotifier>(context, listen: false);
    return Consumer2<OptionsNotifier, EntityNotifier>(builder: (context, _, entityNotifier, __) {
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
              _nameController, (String s) {
                setState(() {
                  _nameErrorMessage = null;
                });
              }),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            buildNameErrorMessage(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            buildRoundsGauge(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            buildNbOfRoundsStatement(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.055),
            ValidationButton(onTap: () async {
                if (_nameController.text.length < 3 || _nameController.text.length > 10) {
                  setState(() {
                    _nameErrorMessage = "Please enter a name with 3-10 chars.";
                  });
                } else {
                  mpNotifier.setGameStatus(GameStatus.loading);
                  String? errorWhileDeletingRoom = await Utils.deleteRoomIfExists();
                  if (errorWhileDeletingRoom == null) {
                    String? errorWhileCreatingRoom = await Utils.createRoomInFirebase(Utils.title(_nameController.text), _nbOfRounds);
                    mpNotifier.setGameStatus(GameStatus.none);
                    if (errorWhileCreatingRoom == null) {
                      entityNotifier.changeGameEntity(Entity.waitingopponent);
                    } else {
                      setState(() {
                        _nameErrorMessage = errorWhileCreatingRoom;
                      });
                    }
                  } else {
                    mpNotifier.setGameStatus(GameStatus.none);
                    setState(() {
                      _nameErrorMessage = errorWhileDeletingRoom;
                    });
                  }
                }
              },
            icon: Icons.check),
          ],
        ),
      );
    });
  }
}
