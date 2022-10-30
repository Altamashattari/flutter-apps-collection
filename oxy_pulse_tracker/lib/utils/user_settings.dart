import '../assets/constants.dart';

class UserSetting {
  String dateFormat;
  TemperatureUnit tempUnit;

  UserSetting({required this.dateFormat, required this.tempUnit});

  Map<String, dynamic> toJson() => {
        'dateFormat': dateFormat,
        'tempUnit': tempUnit.name,
      };
}

UserSetting defaultUserSettings = UserSetting(
  dateFormat: dateMonthYear,
  tempUnit: TemperatureUnit.fahrenheit,
);
