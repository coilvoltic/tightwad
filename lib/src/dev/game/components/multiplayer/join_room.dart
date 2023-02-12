import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/dev/game/components/multiplayer/validation_button.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';
import 'package:tightwad/src/notifiers/multiplayer_notifier.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:flutter/material.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/utils.dart';

class JoinRoom extends StatefulWidget {
  const JoinRoom({Key? key}) : super(key: key);

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  
  String? _idErrorMessage;
  String? _nameErrorMessage;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

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

  Widget buildIdErrorMessage() {
    if (_idErrorMessage == null) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.025,
      );
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.025,
      child: Text(
        _idErrorMessage!,
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
            Utils.buildNeumorphicTextField(
                'ENTER ROOM ID', MediaQuery.of(context).size.width * Utils.ROOM_LOOBY_WIDTH_LIMIT_RATIO,
                _idController, (String s) {
                setState(() {
                  _idErrorMessage = null;
                });
              }, shouldBeOnlyDigit: true),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            buildIdErrorMessage(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            ValidationButton(onTap: () async {
              if (!Utils.areAllFieldsConformal(_nameController.text, _idController.text)) {
                if (!Utils.isNameFormatConformal(_nameController.text)) {
                  setState(() {
                    _nameErrorMessage = "Please enter a name with 3-10 chars.";
                  });
                }
                if (!Utils.isRoomIdFormatConformal(_idController.text)) {
                  setState(() {
                    _idErrorMessage = "Please enter a room id with 6 digits.";
                  });
                }
              } else {
                mpNotifier.setGameStatus(GameStatus.loading);
                String? checkRoomIsFull = await Utils.checkTheRoomIsNotFull(_idController.text);
                if (checkRoomIsFull != null) {
                  setState(() {
                    _idErrorMessage = checkRoomIsFull;
                  });
                  mpNotifier.setGameStatus(GameStatus.none);
                  return;
                }
                String? checkNamesAreNotTheSame = await Utils.checkNamesAreNotTheSame(_nameController.text, _idController.text);
                if (checkNamesAreNotTheSame != null) {
                  setState(() {
                    _nameErrorMessage = checkNamesAreNotTheSame;
                  });
                  mpNotifier.setGameStatus(GameStatus.none);
                  return;
                }
                String? errorWhileJoining = await Utils.joinRoom(Utils.title(_nameController.text), _idController.text);
                if (errorWhileJoining != null) {
                  setState(() {
                    _idErrorMessage = errorWhileJoining;
                  });
                  mpNotifier.setGameStatus(GameStatus.none);
                  return;
                }
                entityNotifier.changeGameEntity(Entity.multiplayergame);
              }
            },
            icon: Icons.check),
          ],
        ),
      );
    });
  }
}
