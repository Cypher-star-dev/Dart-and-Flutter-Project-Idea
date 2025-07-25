// lib/utils/validation_helpers.dart

class ValidationHelpers {
  static String? validateDouble(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value for $fieldName';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number for $fieldName';
    }
    if (double.parse(value) < 0) {
      return '$fieldName cannot be negative';
    }
    return null;
  }
}