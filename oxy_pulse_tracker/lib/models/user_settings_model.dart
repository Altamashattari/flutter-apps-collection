import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oxy_pulse_tracker/constants.dart';
import 'package:oxy_pulse_tracker/utils/shared_pref.dart';
import 'package:oxy_pulse_tracker/utils/user_settings.dart';

class UserSettingModel extends ChangeNotifier {
  UserSetting userSettings = defaultUserSettings;

  UserSettingModel() {
    _fetchSettingsFromStorage();
  }

  _fetchSettingsFromStorage() {
    String? userSettingsString = PreferenceUtils.getString(userSettingskey);
    if (userSettingsString != null) {
      var decodedValue = jsonDecode(userSettingsString);
      userSettings = UserSetting(
        dateFormat: decodedValue["dateFormat"],
        tempUnit: decodedValue["tempUnit"],
      );
      notifyListeners();
    }
  }

  Future<void> updateUserSettings(UserSetting updatedSettings) async {
    await PreferenceUtils.setString(
        userSettingskey, jsonEncode(updatedSettings.toJson()));
    userSettings = updatedSettings;
    notifyListeners();
  }
}
