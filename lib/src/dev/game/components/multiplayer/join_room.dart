import 'dart:math';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:flutter/material.dart';
import 'package:tightwad/src/utils/utils.dart';

class JoinRoom extends StatefulWidget {
  const JoinRoom({Key? key}) : super(key: key);

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {

  bool _isReversed = false;
  String? _idErrorMessage;
  String? _nameErrorMessage;
  int _idTextFieldSizeWhenPb = 0;
  int _nameTextFieldSizeWhenPb = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  Widget buildValidationButton() {
    return GestureDetector(
      onTap: () => {
        if (_idController.text != "123") {
          _idErrorMessage = "Please enter a valid room id.",
          _idTextFieldSizeWhenPb = _idController.text.length,
        },
        if (_nameController.text.length < 3 || _nameController.text.length > 10) {
          _nameErrorMessage = "Please enter a name with 3-10 chars.",
          _nameTextFieldSizeWhenPb = _nameController.text.length,
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS),
        height: Utils.TEXT_FIELD_HEIGHT,
        width: MediaQuery.of(context).size.width * Utils.ROOM_LOOBY_WIDTH_LIMIT_RATIO / 2,
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
                child: Text('click to join!',
                  style: GoogleFonts.bebasNeue(
                    decoration: TextDecoration.none,
                    fontSize: min(min(MediaQuery.of(context).size.width,
                                  MediaQuery.of(context).size.height),
                              500) * 10 * 2 / 392.73,
                    fontWeight: FontWeight.bold,
                    color: Utils.getPassedColorFromTheme(),
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  Widget buildNameErrorMessage() {
    if (_nameErrorMessage == null || _nameController.text.length != _nameTextFieldSizeWhenPb) {
      if (_nameController.text.length != _nameTextFieldSizeWhenPb) {
        _nameErrorMessage = null;
      }
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.025,
      );
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.025,
      child: Text(_nameErrorMessage!,
        style: GoogleFonts.bebasNeue(
          decoration: TextDecoration.none,
          fontSize: min(min(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height),
                    500) * 7 * 2 / 392.73,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildIdErrorMessage() {
    if (_idErrorMessage == null || _idController.text.length != _idTextFieldSizeWhenPb) {
      if (_idController.text.length != _idTextFieldSizeWhenPb) {
        _idErrorMessage = null;
      }
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.025,
      );
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.025,
      child: Text(_idErrorMessage!,
        style: GoogleFonts.bebasNeue(
          decoration: TextDecoration.none,
          fontSize: min(min(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height),
                    500) * 7 * 2 / 392.73,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OptionsNotifier>(
      builder: (context, _, __) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * Utils.ROOM_LOBBY_OPTIONS_HEIGHT_RATIO,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Utils.buildNeumorphicTextField('ENTER YOUR NAME',
                                             MediaQuery.of(context).size.width * Utils.ROOM_LOOBY_WIDTH_LIMIT_RATIO,
                                             _nameController),
              SizedBox(height: MediaQuery.of(context).size.height * 0.005),
              buildNameErrorMessage(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.005),
              Utils.buildNeumorphicTextField('ENTER ROOM ID',
                                             MediaQuery.of(context).size.width * Utils.ROOM_LOOBY_WIDTH_LIMIT_RATIO,
                                             _idController),
              SizedBox(height: MediaQuery.of(context).size.height * 0.005),
              buildIdErrorMessage(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              buildValidationButton(),
            ],
          ),
        );
      }
    );
  }
}