import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../features/clinic/domain/entities/staff_assignment.dart';
import '../../../../../features/clinic/domain/entities/staff_role.dart';
import '../../../../../features/clinic/presentation/cubit/clinic_cubit.dart';
import '../../../../../features/clinic/presentation/cubit/clinic_state.dart';
import '../../cubit/book_appointment_cubit.dart';
import '../../cubit/book_appointment_state.dart';

class SlotSelectorStep extends StatelessWidget {
  final String clinicId;

  const SlotSelectorStep({super.key, required this.clinicId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
      builder: (context, state) {
        final inProgress =
            state is BookAppointmentInProgress ? state : null;
        if (inProgress == null) return const SizedBox.shrink();

        final clinicState = context.watch<ClinicCubit>().state;
        final staff = clinicState is ClinicLoaded
            ? (clinicState.staff ?? [])
                .where((s) =>
                    s.role == StaffRole.doctor && s.isActive)
                .toList()
            : <StaffAssignment>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Provider, Date & Slot',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            DropdownButtonFormField<StaffAssignment>(
              decoration:
                  const InputDecoration(labelText: 'Provider'),
              value: inProgress.selectedProvider,
              items: staff
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s.userName ?? s.userId),
                      ))
                  .toList(),
              onChanged: (provider) {
                if (provider != null) {
                  context
                      .read<BookAppointmentCubit>()
                      .selectProvider(provider);
                }
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today, size: 16),
              label: Text(inProgress.selectedDate != null
                  ? '${inProgress.selectedDate!.day}/${inProgress.selectedDate!.month}/${inProgress.selectedDate!.year}'
                  : 'Select Date'),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                );
                if (picked != null && context.mounted) {
                  context
                      .read<BookAppointmentCubit>()
                      .selectDate(picked);
                  if (inProgress.selectedProvider != null) {
                    await context
                        .read<BookAppointmentCubit>()
                        .loadAvailableSlots(clinicId);
                  }
                }
              },
            ),
            if (inProgress.selectedProvider != null &&
                inProgress.selectedDate != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: inProgress.isLoading
                    ? null
                    : () => context
                        .read<BookAppointmentCubit>()
                        .loadAvailableSlots(clinicId),
                child: inProgress.isLoading
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Load Available Slots'),
              ),
            ],
            if (inProgress.error != null) ...[
              const SizedBox(height: 8),
              Text(inProgress.error!,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error)),
            ],
            if (inProgress.availableSlots.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Available Slots',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: inProgress.availableSlots.map((slot) {
                  return OutlinedButton(
                    onPressed: () => context
                        .read<BookAppointmentCubit>()
                        .selectSlot(slot),
                    child: Text(slot.formattedTimeRange),
                  );
                }).toList(),
              ),
            ],
            if (inProgress.availableSlots.isEmpty &&
                !inProgress.isLoading &&
                inProgress.selectedDate != null &&
                inProgress.selectedProvider != null)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text('No available slots for the selected date.'),
              ),
          ],
        );
      },
    );
  }
}
