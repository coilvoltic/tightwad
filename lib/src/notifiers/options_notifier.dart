import 'package:flutter/material.dart';

import 'package:tightwad/src/database/database.dart';

class OptionsNotifier extends ChangeNotifier {

  void setSoundOn() async {
    await Database.registerSoundSettingOn();
  }

  void setSoundOff() async {
    await Database.registerSoundSettingOff();
  }

  void setLightTheme() async {
    await Database.registerThemeSettingLight();
  }

  void setDarkTheme() async {
    await Database.registerThemeSettingDark();
  }

  void changeTheme()
  {
    if (Database.getThemeSettingLight())
    {
      setDarkTheme();
    }
    else
    {
      setLightTheme();
    }
    notifyListeners();
  }

  void changeVolume()
  {
    if (Database.getSoundSettingOn())
    {
      setSoundOff();
    }
    else
    {
      setSoundOn();
    }
    notifyListeners();
  }

}