import 'package:flutter/material.dart';

import '../../../domain/entities/blood_type.dart';

class BloodTypeDropdown extends StatelessWidget {
  final BloodType? value;
  final ValueChanged<BloodType?> onChanged;

  const BloodTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<BloodType>(
      value: value,
      decoration: const InputDecoration(labelText: 'Blood Type'),
      items: [
        const DropdownMenuItem<BloodType>(
          value: null,
          child: Text('Unknown'),
        ),
        ...BloodType.values.map(
          (bt) => DropdownMenuItem<BloodType>(
            value: bt,
            child: Text(bt.displayName),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
