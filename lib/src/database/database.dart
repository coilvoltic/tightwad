import 'package:shared_preferences/shared_preferences.dart';

class Database {
  static SharedPreferences? _preferences;

  static const _keyTutorialDone      = 'tutorialpass';
  static const _keyLevel             = 'level';
  static const _keyThemeSettingLight = 'theme';
  static const _keySoundSetting      = 'sound';

  static Future init() async =>
    _preferences = await SharedPreferences.getInstance();

  static Future registerTutorialDone() async {
    await _preferences?.setBool(_keyTutorialDone, true);
  }

  static Future registerSoundSettingOn() async {
    await _preferences?.setBool(_keySoundSetting, true);
  }

  static Future registerSoundSettingOff() async {
    await _preferences?.setBool(_keySoundSetting, false);
  }

  static Future registerThemeSettingLight() async {
    await _preferences?.setBool(_keyThemeSettingLight, true);
  }

  static Future registerThemeSettingDark() async {
    await _preferences?.setBool(_keyThemeSettingLight, false);
  }

  static Future registerLevel(int newLevel) async {
    await _preferences?.setInt(_keyLevel, newLevel);
  }

  static Future reinitializeLevel() async {
    await _preferences?.remove(_keyLevel);
  }

  static bool  getTutorialDone()      => _preferences?.getBool(_keyTutorialDone)      ?? false;
  static int   getLevel()             => _preferences?.getInt (_keyLevel)             ?? 0;
  static bool  getThemeSettingLight() => _preferences?.getBool(_keyThemeSettingLight) ?? true;
  static bool  getSoundSettingOn()    => _preferences?.getBool(_keySoundSetting)      ?? true;
}