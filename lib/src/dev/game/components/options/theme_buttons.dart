import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:provider/provider.dart';
import 'package:tightwad/src/notifiers/options_notifier.dart';


class ThemeButtons extends StatefulWidget {
  const ThemeButtons({Key? key}) : super(key: key);

  @override
  State<ThemeButtons> createState() => _ThemeButtonsState();
}

class _ThemeButtonsState extends State<ThemeButtons> {

  Widget buildThemeButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OptionsNotifier>(
      builder: (context, notifier, _) {
        return Visibility(
          visible: notifier.getIsThemeChanging,
          child: Stack(
            children: [
              buildThemeButton(),
              buildThemeButton(),
              buildThemeButton(),
            ],
          ),
        );
      }
    );
  }
}