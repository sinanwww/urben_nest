/// Validation utilities for form inputs
class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  /// Validates phone number (Indian format: 10 digits)
  /// Returns error message if invalid, null if valid
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove spaces and special characters
    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');

    // Check if it's exactly 10 digits
    if (cleaned.length != 10) {
      return 'Phone number must be 10 digits';
    }

    // Check if it starts with valid digits (6-9 for Indian mobile)
    if (!RegExp(r'^[6-9]').hasMatch(cleaned)) {
      return 'Phone number must start with 6, 7, 8, or 9';
    }

    return null;
  }

  /// Validates email address
  /// Returns error message if invalid, null if valid
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // RFC 5322 compliant email regex (simplified)
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  /// Validates name (minimum 2 characters, letters and spaces only)
  /// Returns error message if invalid, null if valid
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    // Allow letters, spaces, and common name characters
    if (!RegExp(r"^[a-zA-Z\s.'-]+$").hasMatch(value)) {
      return 'Name can only contain letters';
    }

    return null;
  }

  /// Validates password (minimum 6 characters)
  /// Returns error message if invalid, null if valid
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Validates community name (minimum 3 characters)
  /// Returns error message if invalid, null if valid
  static String? validateCommunityName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Community name is required';
    }

    if (value.trim().length < 3) {
      return 'Community name must be at least 3 characters';
    }

    return null;
  }

  /// Validates location (required field)
  /// Returns error message if invalid, null if valid
  static String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Location is required';
    }

    if (value.trim().length < 3) {
      return 'Location must be at least 3 characters';
    }

    return null;
  }

  /// Validates required field (generic)
  /// Returns error message if invalid, null if valid
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
