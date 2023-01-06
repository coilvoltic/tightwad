import 'package:flutter/material.dart';

import 'package:tightwad/src/database/database.dart';
import 'package:tightwad/src/utils/common_enums.dart';
import 'package:tightwad/src/utils/utils.dart';

class OptionsNotifier extends ChangeNotifier {

  bool _areSettingsChanging = false;

  void setSoundOn() async {
    await Database.registerSoundSettingOn();
  }

  void setSoundOff() async {
    await Database.registerSoundSettingOff();
  }

  void setGameTheme(int newGameTheme) async {
    await Database.registerGameTheme(newGameTheme);
  }

  void changeTheme(GameTheme newGameTheme) {
    if (newGameTheme == GameTheme.light) {
      setGameTheme(Utils.LIGHT_THEME_INDEX);
    } else if (newGameTheme == GameTheme.dark) {
      setGameTheme(Utils.DARK_THEME_INDEX);
    } else if (newGameTheme == GameTheme.diamond) {
      setGameTheme(Utils.DIAMOND_THEME_INDEX);
    }
    notifyListeners();
  }

  void changeVolume() {
    if (Database.getSoundSettingOn()) {
      setSoundOff();
    } else {
      setSoundOn();
    }
    notifyListeners();
  }

  void updateSettingsChaning() {
    _areSettingsChanging = !_areSettingsChanging;
    notifyListeners();
  }

  bool get getAreSettingsChanging => _areSettingsChanging;

}
