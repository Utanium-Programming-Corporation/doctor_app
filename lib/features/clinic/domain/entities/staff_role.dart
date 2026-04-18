enum StaffRole {
  clinicAdmin,
  doctor,
  receptionist,
  nurse,
  other;

  String get dbValue => switch (this) {
        StaffRole.clinicAdmin => 'clinic_admin',
        StaffRole.doctor => 'doctor',
        StaffRole.receptionist => 'receptionist',
        StaffRole.nurse => 'nurse',
        StaffRole.other => 'other',
      };

  static StaffRole fromDbValue(String value) => switch (value) {
        'clinic_admin' => StaffRole.clinicAdmin,
        'doctor' => StaffRole.doctor,
        'receptionist' => StaffRole.receptionist,
        'nurse' => StaffRole.nurse,
        'other' => StaffRole.other,
        _ => StaffRole.other,
      };

  String get displayName => switch (this) {
        StaffRole.clinicAdmin => 'Clinic Admin',
        StaffRole.doctor => 'Doctor',
        StaffRole.receptionist => 'Receptionist',
        StaffRole.nurse => 'Nurse',
        StaffRole.other => 'Other',
      };
}
