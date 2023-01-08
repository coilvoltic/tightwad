import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Responsive(
        child: Consumer<OptionsNotifier>(
          builder: (context, _, __) {
            return Center(
              child: GestureDetector(
                onTap: () => setState(() {
                  _isPressed = !_isPressed;
                }),
                child: AnimatedContainer(
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
                        hintText: 'ENTER YOUR NAME',
                        hintStyle: GoogleFonts.montserrat(
                        color: Database.getGameTheme() == Utils.DIAMOND_THEME_INDEX ?
                          ThemeColors.labelColor.diamond.withAlpha(70) : ThemeColors.labelColor.lightOrDark.withAlpha(100),
                        fontWeight: FontWeight.bold,
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
