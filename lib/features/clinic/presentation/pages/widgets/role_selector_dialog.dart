import 'package:flutter/material.dart';

import '../../../domain/entities/staff_role.dart';

class RoleSelectorDialog extends StatelessWidget {
  final StaffRole currentRole;

  const RoleSelectorDialog({
    super.key,
    required this.currentRole,
  });

  static Future<StaffRole?> show(
    BuildContext context, {
    required StaffRole currentRole,
  }) {
    return showDialog<StaffRole>(
      context: context,
      builder: (_) => RoleSelectorDialog(currentRole: currentRole),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Role'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: StaffRole.values.map((role) {
          return RadioListTile<StaffRole>(
            title: Text(role.displayName),
            value: role,
            groupValue: currentRole,
            onChanged: (value) => Navigator.of(context).pop(value),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
