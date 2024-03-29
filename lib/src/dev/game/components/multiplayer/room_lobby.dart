import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/dev/game/components/multiplayer/create_room.dart';
import 'package:tightwad/src/dev/game/components/multiplayer/join_room.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/responsive.dart';
import 'package:tightwad/src/utils/utils.dart';

class RoomLobby extends StatefulWidget {
  const RoomLobby({Key? key}) : super(key: key);

  @override
  State<RoomLobby> createState() => _RoomLobbyState();
}

class _RoomLobbyState extends State<RoomLobby> {
  bool _isJoinRoom = false;

  Widget buildIsJoinRoomStatement() {
    return Text(
      'room already\nexists?',
      style: TextStyle(
        fontFamily: 'BebasNeue',
        decoration: TextDecoration.none,
        fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 6),
        fontWeight: FontWeight.bold,
        color: Utils.getPassedColorFromTheme(),
      ),
      textAlign: TextAlign.right,
    );
  }

  GestureDetector buildNeumorphicSwitch() {
    return GestureDetector(
      onTap: () => setState(() {
        _isJoinRoom = !_isJoinRoom;
      }),
      child: Utils.buildNeumorphicSwitch(_isJoinRoom),
    );
  }

  Widget buildJoinRoomChoiceOption() {
    return SizedBox(
      height: MediaQuery.of(context).size.height *
          Utils.ROOM_LOBBY_ROOM_CHOICE_HEIGHT_RATIO,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildIsJoinRoomStatement(),
          const SizedBox(width: 15.0),
          buildNeumorphicSwitch(),
          SizedBox(
              width: MediaQuery.of(context).size.width *
                  (1 - Utils.ROOM_LOOBY_WIDTH_LIMIT_RATIO) /
                  2),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return SizedBox(
      height: MediaQuery.of(context).size.height *
          Utils.ROOM_LOBBY_TITLE_HEIGHT_RATIO,
      child: Center(
        child: Text(
          _isJoinRoom ? 'JOIN\nROOM' : 'CREATE\nROOM',
          style: TextStyle(
            fontFamily: 'Righteous',
            decoration: TextDecoration.none,
            fontSize: Utils.getSizeFromContext(MediaQuery.of(context).size, 25),
            fontWeight: FontWeight.bold,
            color: Utils.getPassedColorFromTheme(),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildChoosenRoomOptions() {
    return _isJoinRoom ? const JoinRoom() : const CreateRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OptionsNotifier>(builder: (context, _, __) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Responsive(
          child: Column(
            children: [
              buildTitle(),
              buildJoinRoomChoiceOption(),
              buildChoosenRoomOptions(),
            ],
          ),
        ),
      );
    });
  }
}
