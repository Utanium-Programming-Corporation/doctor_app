enum Gender {
  male,
  female,
  other;

  static Gender fromString(String value) {
    return switch (value) {
      'male' => Gender.male,
      'female' => Gender.female,
      'other' => Gender.other,
      _ => throw ArgumentError('Unknown gender value: $value'),
    };
  }

  String toDbString() {
    return switch (this) {
      Gender.male => 'male',
      Gender.female => 'female',
      Gender.other => 'other',
    };
  }

  String get displayName {
    return switch (this) {
      Gender.male => 'Male',
      Gender.female => 'Female',
      Gender.other => 'Other',
    };
  }
}
