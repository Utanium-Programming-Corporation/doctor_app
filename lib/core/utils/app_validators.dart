abstract final class AppValidators {
  /// Returns a validator that fails if the value is null or blank.
  static String? Function(String?) required({
    String message = 'This field is required',
  }) {
    return (value) =>
        (value == null || value.trim().isEmpty) ? message : null;
  }

  /// Returns a validator that fails if the value is shorter than [min].
  static String? Function(String?) minLength(int min, {String? message}) {
    return (value) {
      if (value == null || value.length < min) {
        return message ?? 'Must be at least $min characters';
      }
      return null;
    };
  }

  /// Returns a validator that fails if the value exceeds [max] characters.
  static String? Function(String?) maxLength(int max, {String? message}) {
    return (value) {
      if (value != null && value.length > max) {
        return message ?? 'Must be at most $max characters';
      }
      return null;
    };
  }

  /// Returns a validator for optional phone numbers.
  /// Passes if the field is empty; validates format otherwise.
  static String? Function(String?) phone({
    String message = 'Enter a valid phone number',
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      final clean = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
      return RegExp(r'^\+?[0-9]{7,15}$').hasMatch(clean) ? null : message;
    };
  }

  /// Returns a validator for optional email addresses.
  /// Passes if the field is empty; validates format otherwise.
  static String? Function(String?) email({
    String message = 'Enter a valid email address',
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      return RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(value)
          ? null
          : message;
    };
  }

  /// Composes multiple validators, returning the first error found.
  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final v in validators) {
        final error = v(value);
        if (error != null) return error;
      }
      return null;
    };
  }

  /// Returns a validator that fails if the parsed date is in the future.
  /// Expects the value to be a parseable date string (ISO 8601 or similar).
  /// Passes if the field is empty (use with [required] for mandatory dates).
  static String? Function(String?) dateNotFuture({
    String message = 'Date cannot be in the future',
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      final date = DateTime.tryParse(value);
      if (date == null) return 'Enter a valid date';
      if (date.isAfter(DateTime.now())) return message;
      return null;
    };
  }
}
