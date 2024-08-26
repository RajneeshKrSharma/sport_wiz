import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  static const appPref = "APP_PREF";
  static const userPref = "USER_PREF";

  static const sportShopResponse = "sportShopResponse";

  static final SharedPrefUtils _instance = SharedPrefUtils._ctor();

  factory SharedPrefUtils() {
    return _instance;
  }

  SharedPrefUtils._ctor();

  static late SharedPreferences _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // APP_DATA functions

  static setAppStringValue(String key, String value) {
    final String? storedData =
    _prefs.containsKey(appPref) ? _prefs.getString(appPref)! : null;
    Map newData = {key: value};
    Map newDataMap = {};

    if (storedData != null) {
      newDataMap.addAll(jsonDecode(storedData));
      newDataMap.addAll(newData);
    } else {
      newDataMap = newData;
    }

    _prefs.setString(appPref, jsonEncode(newDataMap));
  }

  static setUserStringValue(String key, String value) {
    final String? storedData =
    _prefs.containsKey(userPref) ? _prefs.getString(userPref) : null;
    Map newData = {key: value};
    Map newDataMap = {};

    if (storedData != null) {
      newDataMap.addAll(jsonDecode(storedData));
      newDataMap.addAll(newData);
    } else {
      newDataMap = newData;
    }

    _prefs.setString(userPref, jsonEncode(newDataMap));
  }

  static String getAppStringValue(String key) {
    Map<String, dynamic> allPrefs = _prefs.getString(appPref) != null
        ? jsonDecode(_prefs.getString(appPref) ?? '')
        : {};

    return allPrefs[key] ?? "";
  }

  static String getStringValue(String key) {
    Map<String, dynamic> allPrefs = _prefs.getString(userPref) != null
        ? jsonDecode(_prefs.getString(userPref) ?? '')
        : {};
    return allPrefs[key] ?? '';
  }

  static String getUserStringValue(String key) {
    Map<String, dynamic> allPrefs = _prefs.getString(userPref) != null
        ? jsonDecode(_prefs.getString(userPref) ?? '')
        : {};
    return allPrefs[key] ?? '';
  }

  static Map<String, dynamic> getAllUserPrefs() {
    Map<String, dynamic> allPrefs = _prefs.containsKey(userPref)
        ? jsonDecode(_prefs.getString(userPref)!)
        : {};
    return allPrefs;
  }

  static Map<String, dynamic> getAllAppPrefs() {
    Map<String, dynamic> allPrefs = _prefs.containsKey(appPref)
        ? jsonDecode(_prefs.getString(appPref)!)
        : {};
    return allPrefs;
  }

  static removeValue(String key) {
    return _prefs.remove(key);
  }

  ////////////////////////////// SETTERS  /////////////////////////////////////////

  static set playerToken(String value)    => setUserStringValue(sportShopResponse, value);


  /////////////////////////// GETTERS //////////////////////////////

  static String get playerToken => getStringValue(sportShopResponse);
}

enum PrefType { appPref, userPref }

extension PrefExtension on PrefType {
  String get value {
    switch (this) {
      case PrefType.appPref:
        return SharedPrefUtils.appPref;
      case PrefType.userPref:
        return SharedPrefUtils.userPref;
    }
  }
}
