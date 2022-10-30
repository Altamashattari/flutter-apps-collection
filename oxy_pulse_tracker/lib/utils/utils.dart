import 'package:oxy_pulse_tracker/assets/constants.dart';

class Utils {
  static String getTemperatureUnitString(String? tempUnit) {
    tempUnit = tempUnit ?? TemperatureUnit.fahrenheit.toShortString();
    return tempUnit == "fahrenheit" ? "°F" : "°C";
  }
}
