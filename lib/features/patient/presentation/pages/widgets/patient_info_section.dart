import 'package:flutter/material.dart';

import '../../../domain/entities/patient.dart';

class PatientInfoSection extends StatelessWidget {
  final Patient patient;

  const PatientInfoSection({super.key, required this.patient});

  Widget _row(BuildContext context, String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _row(context, 'Patient No.', patient.patientNumber),
        _row(context, 'Full Name', patient.fullName),
        _row(context, 'Date of Birth',
            patient.dateOfBirth.toIso8601String().split('T')[0]),
        _row(context, 'Age', '${patient.age} years'),
        _row(context, 'Gender', patient.gender?.displayName),
        _row(context, 'Blood Type', patient.bloodType?.displayName),
        _row(context, 'Phone', patient.phoneNumber),
        _row(context, 'Email', patient.email),
        _row(context, 'National ID', patient.nationalId),
        _row(context, 'Address', patient.address),
        _row(context, 'Emergency Contact', patient.emergencyContactName),
        _row(context, 'Emergency Phone', patient.emergencyContactPhone),
        _row(context, 'Notes', patient.notes),
      ],
    );
  }
}
