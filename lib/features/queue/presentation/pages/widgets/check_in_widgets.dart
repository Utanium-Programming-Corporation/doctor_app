import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../../scheduling/domain/entities/appointment.dart';
import '../../../domain/entities/queue_priority.dart';
import '../../../domain/usecases/check_in_patient.dart';
import '../../bloc/walk_in_cubit.dart';
import '../../bloc/walk_in_state.dart';

class WalkInFormWidget extends StatefulWidget {
  final String clinicId;
  final String providerId;
  final String patientId;
  final VoidCallback onSuccess;
  final VoidCallback onCancel;

  const WalkInFormWidget({
    super.key,
    required this.clinicId,
    required this.providerId,
    required this.patientId,
    required this.onSuccess,
    required this.onCancel,
  });

  @override
  State<WalkInFormWidget> createState() => _WalkInFormWidgetState();
}

class _WalkInFormWidgetState extends State<WalkInFormWidget> {
  bool _urgent = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WalkInCubit>(),
      child: BlocListener<WalkInCubit, WalkInState>(
        listener: (context, state) {
          if (state is WalkInSuccess) widget.onSuccess();
          if (state is WalkInError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<WalkInCubit, WalkInState>(
          builder: (context, state) {
            final isLoading = state is WalkInLoading;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckboxListTile(
                  title: const Text('Mark as Urgent'),
                  value: _urgent,
                  onChanged: (v) => setState(() => _urgent = v ?? false),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: widget.onCancel,
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<WalkInCubit>().checkIn(
                                    CheckInPatientParams(
                                      clinicId: widget.clinicId,
                                      patientId: widget.patientId,
                                      providerId: widget.providerId,
                                      priority: _urgent
                                          ? QueuePriority.urgent
                                          : QueuePriority.normal,
                                    ),
                                  );
                            },
                      child: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Check In'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CheckInAppointmentList extends StatelessWidget {
  final List<Appointment> appointments;
  final void Function(Appointment) onCheckIn;

  const CheckInAppointmentList({
    super.key,
    required this.appointments,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('No scheduled appointments today')),
      );
    }
    return Column(
      children: appointments
          .map(
            (a) => ListTile(
              title: Text(a.patientName ?? a.patientId),
              subtitle: Text(a.providerName ?? 'Provider'),
              trailing: ElevatedButton(
                onPressed: () => onCheckIn(a),
                child: const Text('Check In'),
              ),
            ),
          )
          .toList(),
    );
  }
}
