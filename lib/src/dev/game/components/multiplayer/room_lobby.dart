import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';
import 'package:tightwad/src/utils/colors.dart';
import 'package:tightwad/src/utils/responsive.dart';
import 'package:tightwad/src/utils/utils.dart';

class RoomLobby extends StatefulWidget {
  const RoomLobby({Key? key}) : super(key: key);

  @override
  State<RoomLobby> createState() => _RoomLobbyState();
}

class _RoomLobbyState extends State<RoomLobby> {

  AnimatedContainer buildNeumorphicTextField(final String hintText) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS),
      height: 50,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: Utils.buildNeumorphismBox(50.0, 5.0, 5.0, true),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: TextField(
          cursorColor: Database.getGameTheme() == Utils.DIAMOND_THEME_INDEX ?
              ThemeColors.labelColor.diamond : ThemeColors.labelColor.lightOrDark,
          style: GoogleFonts.montserrat(
            color: Database.getGameTheme() == Utils.DIAMOND_THEME_INDEX ?
              ThemeColors.labelColor.diamond : ThemeColors.labelColor.lightOrDark,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'(\w+)'),
            ),
          ],
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: GoogleFonts.montserrat(
            color: Database.getGameTheme() == Utils.DIAMOND_THEME_INDEX ?
              ThemeColors.labelColor.diamond.withAlpha(70) : ThemeColors.labelColor.lightOrDark.withAlpha(100),
            fontWeight: FontWeight.bold,
            ),
          ),
          textInputAction: TextInputAction.done,
        ),
      ),
    );
  }

  bool _switch = false;

  GestureDetector buildNeumorphicSwitch() {
    return GestureDetector(
      onTap: () => setState(() {
          _switch = !_switch;
      }),
      child: TweenAnimationBuilder<Alignment>(
        tween: Tween<Alignment>(begin: Alignment.centerLeft, end: _switch ? Alignment.centerRight : Alignment.centerLeft),
        duration: const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS - 50),
        builder: (_, alignment, __) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS),
            height: 40,
            width: 80,
            decoration: Utils.buildNeumorphismBox(18.0, 3.0, 3.0, true),
            alignment: alignment,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: Utils.THEME_ANIMATION_DURATION_MS),
                height: 25,
                width: 25,
                decoration: Utils.buildNeumorphismBox(25.0, 3.0, 3.0, false),
              ),
            ),
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Responsive(
        child: Consumer<OptionsNotifier>(
          builder: (context, _, __) {
            return Stack(
              children: [
                Center(
                  child: buildNeumorphicTextField('ENTER YOUR NAME'),
                ),
                buildNeumorphicSwitch(),
              ],
            );
          }
        ),
      ),
    );
  }
}
