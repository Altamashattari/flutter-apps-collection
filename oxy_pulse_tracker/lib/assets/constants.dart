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

const dateFormats = [
  {
    "value": "MM/dd/yyyy",
  },
  {
    "value": "dd/MM/yyyy",
  },
  {
    "value": "yyyy/MM/dd",
  },
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
