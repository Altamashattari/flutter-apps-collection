import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:settings_ui/settings_ui.dart';
import '../assets/constants.dart';
import '../utils/user_settings.dart';

const key = "user_settings";

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // ignore: prefer_final_fields
  UserSetting _setting = UserSetting(
    dateFormat: "MM/dd/yyyy",
    tempUnit: TemperatureUnit.fahrenheit,
  );
  late SharedPreferences _pref;
  bool hasError = false;
  bool loading = false;

  _getSharedPreferenceInstance() async {
    try {
      loading = true;
      final value = await SharedPreferences.getInstance();
      String? userSettings = value.getString(key);
      setState(() {
        _pref = value;
        if (userSettings != null) {
          var decodedValue = jsonDecode(userSettings);
          _setting = UserSetting(
            dateFormat: decodedValue["dateFormat"],
            tempUnit: TemperatureUnit.values.byName(decodedValue["tempUnit"]),
          );
        }
      });
    } catch (e) {
      setState(() {
        hasError = true;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  _setUserSetting() {
    _pref.setString(key, jsonEncode(_setting.toJson()));
  }

  @override
  void initState() {
    _getSharedPreferenceInstance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Settings"),
      ),
      body: _getBodyWidget(),
    );
  }

  Widget _getBodyWidget() {
    if (loading) {
      return const Center(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (hasError) {
      return const Center(
        child: Text(
          "Unexpected error occurred",
        ),
      );
    }
    String temperatureText = temperatureUnitDropdownItems
        .firstWhere((element) => element.value == _setting.tempUnit)
        .text;
    return SettingsList(
      sections: [
        SettingsSection(
          title: const Text('Log Setting'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: const Icon(Icons.date_range_outlined),
              title: const Text('Date Format'),
              value: Text(_setting.dateFormat),
              onPressed: (context) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          "Select Date Format",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: SizedBox(
                          height: 200,
                          child: Column(
                            children: dateFormats
                                .map(
                                  (format) => RadioListTile(
                                    title: Text(format['value']!),
                                    value: format['value']!,
                                    groupValue: _setting.dateFormat,
                                    selected:
                                        _setting.dateFormat == format['value'],
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null) {
                                          _setting.dateFormat = value;
                                          _setUserSetting();
                                        }
                                      });

                                      Navigator.of(context).pop();
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    });
              },
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.stream_outlined),
              title: const Text('Temperature Unit'),
              value: Text(temperatureText),
              onPressed: (context) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          "Select Preferred Temp Unit",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: SizedBox(
                          height: 150,
                          child: Column(
                            children: temperatureUnitDropdownItems
                                .map(
                                  (unit) => RadioListTile(
                                    title: Text(unit.text),
                                    value: unit.value,
                                    groupValue: _setting.tempUnit,
                                    selected: _setting.tempUnit == unit.value,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null) {
                                          _setting.tempUnit = unit.value;
                                          _setUserSetting();
                                        }
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    });
              },
            ),
          ],
        ),
      ],
    );
  }
}
