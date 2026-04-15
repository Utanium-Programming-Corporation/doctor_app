import 'package:flutter/material.dart';

import '../../../domain/entities/clinic_type.dart';

class ClinicTypeDropdown extends StatelessWidget {
  final ClinicType? value;
  final ValueChanged<ClinicType?> onChanged;
  final String? Function(ClinicType?)? validator;

  const ClinicTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ClinicType>(
      value: value,
      decoration: const InputDecoration(labelText: 'Clinic Type'),
      validator: validator,
      onChanged: onChanged,
      items: ClinicType.values.map((type) {
        return DropdownMenuItem<ClinicType>(
          value: type,
          child: Text(type.displayName),
        );
      }).toList(),
    );
  }
}
