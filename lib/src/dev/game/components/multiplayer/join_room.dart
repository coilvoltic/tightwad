import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/dev/game/components/multiplayer/validation_button.dart';
import 'package:tightwad/src/notifiers/entity_notifier.dart';
import 'package:tightwad/src/notifiers/loading_notifier.dart';
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
  int _idTextFieldSizeWhenPb = 0;
  int _nameTextFieldSizeWhenPb = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

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
    if (_idErrorMessage == null ||
        _idController.text.length != _idTextFieldSizeWhenPb) {
      if (_idController.text.length != _idTextFieldSizeWhenPb) {
        _idErrorMessage = null;
      }
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
    return Consumer3<OptionsNotifier, EntityNotifier, LoadingNotifier>(builder: (context, _, entityNotifier, loadingNotifier, __) {
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
            Utils.buildNeumorphicTextField(
                'ENTER ROOM ID', MediaQuery.of(context).size.width * Utils.ROOM_LOOBY_WIDTH_LIMIT_RATIO,
                _idController, shouldBeOnlyDigit: true),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            buildIdErrorMessage(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            ValidationButton(onTap: () async {
              if (!Utils.areAllFieldsConformal(_nameController.text, _idController.text)) {
                if (!Utils.isNameFormatConformal(_nameController.text)) {
                  _nameErrorMessage = "Please enter a name with 3-10 chars.";
                  _nameTextFieldSizeWhenPb = _nameController.text.length;
                }
                if (!Utils.isRoomIdFormatConformal(_idController.text)) {
                  _idErrorMessage = "Please enter a room id with 6 digits.";
                  _idTextFieldSizeWhenPb = _idController.text.length;
                }
              } else {
                loadingNotifier.setIsLoading();
                String? checkRoomIsFull = await Utils.checkTheRoomIsNotFull(_idController.text);
                if (checkRoomIsFull != null) {
                  _idErrorMessage = checkRoomIsFull;
                  _idTextFieldSizeWhenPb = _idController.text.length;
                  loadingNotifier.unsetIsLoading();
                  return;
                }
                String? checkNamesAreNotTheSame = await Utils.checkNamesAreNotTheSame(_nameController.text, _idController.text);
                if (checkNamesAreNotTheSame != null) {
                  _nameErrorMessage = checkNamesAreNotTheSame;
                  _nameTextFieldSizeWhenPb = _nameController.text.length;
                  loadingNotifier.unsetIsLoading();
                  return;
                }
                String? errorWhileJoining = await Utils.joinRoom(_nameController.text, _idController.text);
                if (errorWhileJoining != null) {
                  _idErrorMessage = errorWhileJoining;
                  _idTextFieldSizeWhenPb = _idController.text.length;
                  loadingNotifier.unsetIsLoading();
                  return;
                }
                entityNotifier.changeGameEntity(Entity.multiplayergame);
                loadingNotifier.unsetIsLoading();
              }
            },
            text: 'click to join!'),
          ],
        ),
      );
    });
  }
}
