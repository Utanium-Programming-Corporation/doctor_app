import 'package:flutter/material.dart';

import '../../../domain/entities/appointment.dart';
import '../../../domain/entities/appointment_status.dart';

class AppointmentListTile extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onTap;

  const AppointmentListTile({
    super.key,
    required this.appointment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorHex = appointment.appointmentTypeColor?.replaceFirst('#', '');
    final typeColor = colorHex != null
        ? Color(int.parse('FF$colorHex', radix: 16))
        : Colors.grey;

    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: typeColor, radius: 4),
        title: Text(appointment.patientName ?? appointment.patientId),
        subtitle: Text(
          '${appointment.appointmentTypeName ?? ''}'
          '${appointment.providerName != null ? ' • ${appointment.providerName}' : ''}'
          '\n${_formatTime(appointment.startTime)} – ${_formatTime(appointment.endTime)}',
        ),
        trailing: _StatusChip(status: appointment.status),
        onTap: onTap,
        isThreeLine: true,
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _StatusChip extends StatelessWidget {
  final AppointmentStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      AppointmentStatus.scheduled => Colors.blue,
      AppointmentStatus.confirmed => Colors.teal,
      AppointmentStatus.checkedIn => Colors.orange,
      AppointmentStatus.inProgress => Colors.amber,
      AppointmentStatus.completed => Colors.green,
      AppointmentStatus.cancelled => Colors.red,
      AppointmentStatus.noShow => Colors.grey,
    };
    return Chip(
      label: Text(
        status.displayName,
        style: const TextStyle(fontSize: 11, color: Colors.white),
      ),
      backgroundColor: color,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );
  }
}
