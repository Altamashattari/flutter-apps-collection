class InputValidator {
  static bool isValidNumber(String? value) {
    String? trimmedValue = value?.trim();
    if (trimmedValue == null ||
        trimmedValue.isEmpty ||
        double.tryParse(trimmedValue) == null) {
      return false;
    }
    return true;
  }

  static bool isValueEmpty(String? value) {
    return value == null || value.isEmpty;
  }
}
