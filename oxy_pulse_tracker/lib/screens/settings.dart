import 'package:flutter/material.dart';
import 'package:oxy_pulse_tracker/models/user_settings_model.dart';
import 'package:provider/provider.dart';

import 'package:settings_ui/settings_ui.dart';
import '../constants.dart';
import '../utils/user_settings.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late UserSettingModel _userSettingModel;

  _setUserSetting(UserSetting userSettings) {
    _userSettingModel.updateUserSettings(userSettings);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userSettingModel = Provider.of<UserSettingModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Settings"),
      ),
      body: _getBodyWidget(),
    );
  }

  Widget _getBodyWidget() {
    String temperatureText = temperatureUnitDropdownItems
        .firstWhere((element) =>
            element.value == _userSettingModel.userSettings.tempUnit)
        .text;
    return SettingsList(
      sections: [
        SettingsSection(
          title: const Text(
            'Log Settings',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: const Icon(Icons.date_range_outlined),
              title: const Text('Date Format'),
              value: Text(_userSettingModel.userSettings.dateFormat),
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
                                    groupValue: _userSettingModel
                                        .userSettings.dateFormat,
                                    selected: _userSettingModel
                                            .userSettings.dateFormat ==
                                        format['value'],
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null) {
                                          _setUserSetting(
                                            UserSetting(
                                              dateFormat: value,
                                              tempUnit: _userSettingModel
                                                  .userSettings.tempUnit,
                                            ),
                                          );
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
                                    groupValue:
                                        _userSettingModel.userSettings.tempUnit,
                                    selected: _userSettingModel
                                            .userSettings.tempUnit ==
                                        unit.value,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null) {
                                          _setUserSetting(
                                            UserSetting(
                                              tempUnit: unit.value,
                                              dateFormat: _userSettingModel
                                                  .userSettings.dateFormat,
                                            ),
                                          );
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
