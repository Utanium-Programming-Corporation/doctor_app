import 'package:flutter/material.dart';

import '../../../domain/entities/patient.dart';

class PatientListTile extends StatelessWidget {
  final Patient patient;
  final VoidCallback onTap;

  const PatientListTile({
    super.key,
    required this.patient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(patient.fullName),
      subtitle: Text(patient.phoneNumber),
      leading: CircleAvatar(child: Text(patient.firstName[0].toUpperCase())),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            patient.patientNumber,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Text(
            '${patient.age} yrs',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
