import '../assets/constants.dart';

class UserSetting {
  String dateFormat;
  String tempUnit;

  UserSetting({required this.dateFormat, required this.tempUnit});

  Map<String, dynamic> toJson() => {
        'dateFormat': dateFormat,
        'tempUnit': tempUnit,
      };
}

UserSetting defaultUserSettings = UserSetting(
  dateFormat: dateMonthYear,
  tempUnit: TemperatureUnit.fahrenheit.toShortString(),
);
