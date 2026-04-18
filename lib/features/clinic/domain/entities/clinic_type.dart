enum ClinicType {
  generalPractice,
  dental,
  dermatology,
  pediatrics,
  orthopedics,
  ophthalmology,
  cardiology,
  multiSpecialty,
  other;

  String get dbValue => switch (this) {
        ClinicType.generalPractice => 'general_practice',
        ClinicType.dental => 'dental',
        ClinicType.dermatology => 'dermatology',
        ClinicType.pediatrics => 'pediatrics',
        ClinicType.orthopedics => 'orthopedics',
        ClinicType.ophthalmology => 'ophthalmology',
        ClinicType.cardiology => 'cardiology',
        ClinicType.multiSpecialty => 'multi_specialty',
        ClinicType.other => 'other',
      };

  static ClinicType fromDbValue(String value) => switch (value) {
        'general_practice' => ClinicType.generalPractice,
        'dental' => ClinicType.dental,
        'dermatology' => ClinicType.dermatology,
        'pediatrics' => ClinicType.pediatrics,
        'orthopedics' => ClinicType.orthopedics,
        'ophthalmology' => ClinicType.ophthalmology,
        'cardiology' => ClinicType.cardiology,
        'multi_specialty' => ClinicType.multiSpecialty,
        'other' => ClinicType.other,
        _ => ClinicType.other,
      };

  String get displayName => switch (this) {
        ClinicType.generalPractice => 'General Practice',
        ClinicType.dental => 'Dental',
        ClinicType.dermatology => 'Dermatology',
        ClinicType.pediatrics => 'Pediatrics',
        ClinicType.orthopedics => 'Orthopedics',
        ClinicType.ophthalmology => 'Ophthalmology',
        ClinicType.cardiology => 'Cardiology',
        ClinicType.multiSpecialty => 'Multi-Specialty',
        ClinicType.other => 'Other',
      };
}
