import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/route_names.dart';
import '../cubit/appointment_detail_cubit.dart';
import '../cubit/appointment_detail_state.dart';
import 'widgets/status_action_buttons.dart';

class AppointmentDetailPage extends StatelessWidget {
  final String appointmentId;

  const AppointmentDetailPage({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return sl<AppointmentDetailCubit>()..loadAppointment(appointmentId);
      },
      child: const _AppointmentDetailView(),
    );
  }
}

class _AppointmentDetailView extends StatelessWidget {
  const _AppointmentDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment')),
      body: BlocBuilder<AppointmentDetailCubit, AppointmentDetailState>(
        builder: (context, state) {
          return switch (state) {
            AppointmentDetailInitial() ||
            AppointmentDetailLoading() =>
              const Center(child: CircularProgressIndicator()),
            AppointmentDetailError(:final message) =>
              Center(child: Text(message)),
            AppointmentDetailLoaded(:final appointment, :final isUpdating) =>
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Row('Patient',
                        appointment.patientName ?? appointment.patientId),
                    _Row('Type',
                        appointment.appointmentTypeName ?? appointment.appointmentTypeId),
                    _Row('Provider',
                        appointment.providerName ?? appointment.providerId),
                    _Row(
                      'Date',
                      '${appointment.startTime.day}/${appointment.startTime.month}/${appointment.startTime.year}',
                    ),
                    _Row(
                      'Time',
                      '${_fmt(appointment.startTime)} – ${_fmt(appointment.endTime)}',
                    ),
                    _Row('Status', appointment.status.displayName),
                    if (appointment.notes != null)
                      _Row('Notes', appointment.notes!),
                    if (appointment.cancelReason != null)
                      _Row('Cancel Reason', appointment.cancelReason!),
                    const SizedBox(height: 24),
                    if (!appointment.status.isTerminal) ...[
                      Text('Actions',
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      if (isUpdating)
                        const Center(child: CircularProgressIndicator())
                      else ...[
                        StatusActionButtons(appointment: appointment),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: () => context.pushNamed(
                            RouteNames.bookAppointment,
                            queryParameters: {
                              'reschedule': appointment.id,
                            },
                          ),
                          icon: const Icon(Icons.schedule),
                          label: const Text('Reschedule'),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
          };
        },
      ),
    );
  }

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text('$label:',
                style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
