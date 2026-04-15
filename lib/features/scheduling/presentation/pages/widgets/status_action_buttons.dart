import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/appointment.dart';
import '../../../domain/entities/appointment_status.dart';
import '../../cubit/appointment_detail_cubit.dart';

class StatusActionButtons extends StatelessWidget {
  final Appointment appointment;

  const StatusActionButtons({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final nextStatuses = AppointmentStatus.values.where((s) =>
        appointment.status.canTransitionTo(s) &&
        s != AppointmentStatus.cancelled);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...nextStatuses.map((s) => ElevatedButton(
              onPressed: () =>
                  context.read<AppointmentDetailCubit>().updateStatus(
                        appointmentId: appointment.id,
                        newStatus: s,
                      ),
              child: Text(s.displayName),
            )),
        if (appointment.canCancel)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              side: BorderSide(color: Theme.of(context).colorScheme.error),
            ),
            onPressed: () => _showCancelDialog(context),
            child: const Text('Cancel'),
          ),
      ],
    );
  }

  Future<void> _showCancelDialog(BuildContext context) async {
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: TextField(
          controller: reasonController,
          decoration:
              const InputDecoration(labelText: 'Reason (optional)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<AppointmentDetailCubit>().cancelAppointment(
            appointmentId: appointment.id,
            reason: reasonController.text.trim().isEmpty
                ? null
                : reasonController.text.trim(),
          );
    }
    reasonController.dispose();
  }
}
