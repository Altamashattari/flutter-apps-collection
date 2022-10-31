import 'package:intl/intl.dart';
import 'package:oxy_pulse_tracker/constants.dart';

class Utils {
  static String getTemperatureUnitString(String? tempUnit) {
    tempUnit = tempUnit ?? TemperatureUnit.fahrenheit.toShortString();
    return tempUnit == "fahrenheit" ? "°F" : "°C";
  }

  static String getDisplayDate(DateTime date, String dateFormat) {
    return DateFormat(dateFormat).format(date);
  }

  static String getDisplayTime(DateTime date) {
    return DateFormat("h:mm a").format(date);
  }

  static List<List<T>> chunk<T>(
      {required List<T> array, required int chunkSize}) {
    var len = array.length;
    List<List<T>> chunks = [];

    for (var i = 0; i < len; i += chunkSize) {
      var end = (i + chunkSize < len) ? i + chunkSize : len;
      chunks.add(array.sublist(i, end));
    }
    return chunks;
  }
}
