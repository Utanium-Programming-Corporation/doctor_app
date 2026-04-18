import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/book_appointment_cubit.dart';
import '../../cubit/book_appointment_state.dart';

class BookingConfirmationStep extends StatelessWidget {
  final String clinicId;

  const BookingConfirmationStep({super.key, required this.clinicId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
      builder: (context, state) {
        if (state is! BookAppointmentInProgress) {
          return const SizedBox.shrink();
        }
        final s = state;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Confirm Booking',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            _ConfirmRow(
              label: 'Patient',
              value: s.selectedPatient?.fullName ?? '-',
            ),
            _ConfirmRow(
              label: 'Type',
              value: s.selectedAppointmentType?.name ?? '-',
            ),
            _ConfirmRow(
              label: 'Provider',
              value: s.selectedProvider?.userName ??
                  s.selectedProvider?.userId ??
                  '-',
            ),
            if (s.selectedDate != null)
              _ConfirmRow(
                label: 'Date',
                value:
                    '${s.selectedDate!.day}/${s.selectedDate!.month}/${s.selectedDate!.year}',
              ),
            if (s.selectedSlot != null)
              _ConfirmRow(
                label: 'Time',
                value: s.selectedSlot!.formattedTimeRange,
              ),
            if (s.error != null) ...[
              const SizedBox(height: 12),
              Text(s.error!,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: s.isLoading
                    ? null
                    : () => context
                        .read<BookAppointmentCubit>()
                        .confirmBooking(clinicId),
                child: s.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Confirm Appointment'),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String label;
  final String value;

  const _ConfirmRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text('$label:',
                style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
