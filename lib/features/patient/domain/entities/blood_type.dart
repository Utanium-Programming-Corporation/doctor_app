enum BloodType {
  aPositive,
  aNegative,
  bPositive,
  bNegative,
  abPositive,
  abNegative,
  oPositive,
  oNegative;

  static BloodType fromDbValue(String value) {
    return switch (value) {
      'A+' => BloodType.aPositive,
      'A-' => BloodType.aNegative,
      'B+' => BloodType.bPositive,
      'B-' => BloodType.bNegative,
      'AB+' => BloodType.abPositive,
      'AB-' => BloodType.abNegative,
      'O+' => BloodType.oPositive,
      'O-' => BloodType.oNegative,
      _ => throw ArgumentError('Unknown blood type value: $value'),
    };
  }

  String toDbValue() {
    return switch (this) {
      BloodType.aPositive => 'A+',
      BloodType.aNegative => 'A-',
      BloodType.bPositive => 'B+',
      BloodType.bNegative => 'B-',
      BloodType.abPositive => 'AB+',
      BloodType.abNegative => 'AB-',
      BloodType.oPositive => 'O+',
      BloodType.oNegative => 'O-',
    };
  }

  String get displayName {
    return switch (this) {
      BloodType.aPositive => 'A+',
      BloodType.aNegative => 'A−',
      BloodType.bPositive => 'B+',
      BloodType.bNegative => 'B−',
      BloodType.abPositive => 'AB+',
      BloodType.abNegative => 'AB−',
      BloodType.oPositive => 'O+',
      BloodType.oNegative => 'O−',
    };
  }
}
