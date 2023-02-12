import 'package:shared_preferences/shared_preferences.dart';
import 'package:tightwad/src/utils/utils.dart';

class Database {
  static SharedPreferences? _preferences;

  static const _keyGameEntity   = 'entity';
  static const _keyLevel        = 'level';
  static const _keyGameTheme    = 'theme';
  static const _keySoundSetting = 'sound';
  static const _keyRoomId       = 'roomId';
  static const _keyIsBoss       = 'isBoss';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
    if (Database.getGameEntity() == Utils.MULTIPLAYERGAME_ENTITY_INDEX ||
        Database.getGameEntity() == Utils.WAITINGOPPONENT_ENTITY_INDEX) {
      registerGameEntity(Utils.LOBBY_ENTITY_INDEX);
    }
  }

  static Future registerGameEntity(int newGameEntity) async {
    await _preferences?.setInt(_keyGameEntity, newGameEntity);
  }

  static Future registerSoundSettingOn() async {
    await _preferences?.setBool(_keySoundSetting, true);
  }

  static Future registerSoundSettingOff() async {
    await _preferences?.setBool(_keySoundSetting, false);
  }

  static Future registerGameTheme(int newGameTheme) async {
    await _preferences?.setInt(_keyGameTheme, newGameTheme);
  }

  static Future registerLevel(int newLevel) async {
    await _preferences?.setInt(_keyLevel, newLevel);
  }

  static Future reinitializeLevel() async {
    await _preferences?.remove(_keyLevel);
  }

  static Future registerRoomId(String newRoomid) async {
    await _preferences?.setString(_keyRoomId, newRoomid);
  }

  static Future registerIsBoss() async {
    await _preferences?.setBool(_keyIsBoss, true);
  }

  static int    getGameEntity()     => _preferences?.getInt   (_keyGameEntity)   ?? Utils.SINGLEPLAYERWELCOME_ENTITY_INDEX;
  static int    getLevel()          => _preferences?.getInt   (_keyLevel)        ?? 0;
  static int    getGameTheme()      => _preferences?.getInt   (_keyGameTheme)    ?? Utils.LIGHT_THEME_INDEX;
  static bool   getSoundSettingOn() => _preferences?.getBool  (_keySoundSetting) ?? true;
  static String getRoomId()         => _preferences?.getString(_keyRoomId)       ?? '-1';
  static bool   getIsBoss()         => _preferences?.getBool  (_keyIsBoss)       ?? false;
}
