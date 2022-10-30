enum TemperatureUnit {
  fahrenheit,
  celsius,
}

const String memberListBox = "member_list";

const List<String> defaultRelations = [
  "Self",
  "Father",
  "Mother",
  "Brother",
  "Sister",
  "Son",
  "Daughter",
  "Husband",
  "Wife",
  "Other",
];

const dateMonthYear = "dd/MM/yyyy";
const monthDateYear = "MM/dd/yyyy";
const yearMonthDate = "yyyy/MM/dd";

const dateFormats = [
  {"value": monthDateYear},
  {"value": dateMonthYear},
  {"value": yearMonthDate},
];

class TemperatureUnitDropdownItem {
  final String text;
  final TemperatureUnit value;

  TemperatureUnitDropdownItem({
    required this.text,
    required this.value,
  });
}

var temperatureUnitDropdownItems = [
  TemperatureUnitDropdownItem(
    text: "Fahrenheit",
    value: TemperatureUnit.fahrenheit,
  ),
  TemperatureUnitDropdownItem(
    text: "Celsius",
    value: TemperatureUnit.celsius,
  ),
];

const userSettingskey = "user_settings";
