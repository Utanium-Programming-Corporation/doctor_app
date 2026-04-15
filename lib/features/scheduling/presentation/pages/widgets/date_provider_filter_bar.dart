import 'package:flutter/material.dart';

import '../../../../../features/clinic/domain/entities/staff_assignment.dart';
import '../../../../../features/clinic/domain/entities/staff_role.dart';

class DateProviderFilterBar extends StatelessWidget {
  final DateTime selectedDate;
  final String? selectedProviderId;
  final List<StaffAssignment> staff;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String?> onProviderChanged;

  const DateProviderFilterBar({
    super.key,
    required this.selectedDate,
    this.selectedProviderId,
    required this.staff,
    required this.onDateChanged,
    required this.onProviderChanged,
  });

  List<StaffAssignment> get _doctors =>
      staff.where((s) => s.role == StaffRole.doctor && s.isActive).toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today, size: 16),
              label: Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              ),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  onDateChanged(picked);
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String?>(
              decoration: const InputDecoration(
                labelText: 'Provider',
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              value: selectedProviderId,
              items: [
                const DropdownMenuItem(value: null, child: Text('All')),
                ..._doctors.map((s) => DropdownMenuItem(
                      value: s.userId,
                      child: Text(s.userName ?? s.userId,
                          overflow: TextOverflow.ellipsis),
                    )),
              ],
              onChanged: onProviderChanged,
            ),
          ),
        ],
      ),
    );
  }
}
