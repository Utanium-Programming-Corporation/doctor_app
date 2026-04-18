import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/route_names.dart';
import '../../../clinic/presentation/cubit/clinic_cubit.dart';
import '../../../clinic/presentation/cubit/clinic_state.dart';
import '../../../scheduling/domain/entities/appointment.dart';
import '../../../scheduling/domain/entities/appointment_status.dart';
import '../../../scheduling/presentation/cubit/appointment_list_cubit.dart';
import '../../../scheduling/presentation/cubit/appointment_list_state.dart';
import '../../domain/usecases/check_in_patient.dart';
import 'widgets/check_in_widgets.dart';

class CheckInPage extends StatelessWidget {
  final String? appointmentId;

  const CheckInPage({super.key, this.appointmentId});

  @override
  Widget build(BuildContext context) {
    final clinicState = context.read<ClinicCubit>().state;
    final clinicId =
        clinicState is ClinicLoaded ? (clinicState.selectedClinicId ?? '') : '';
    final providerId =
        Supabase.instance.client.auth.currentUser?.id ?? '';

    return BlocProvider(
      create: (_) {
        final cubit = sl<AppointmentListCubit>();
        if (clinicId.isNotEmpty) {
          cubit.loadAppointments(clinicId: clinicId, date: DateTime.now());
        }
        return cubit;
      },
      child: _CheckInView(
        clinicId: clinicId,
        providerId: providerId,
        initialAppointmentId: appointmentId,
      ),
    );
  }
}

class _CheckInView extends StatefulWidget {
  final String clinicId;
  final String providerId;
  final String? initialAppointmentId;

  const _CheckInView({
    required this.clinicId,
    required this.providerId,
    this.initialAppointmentId,
  });

  @override
  State<_CheckInView> createState() => _CheckInViewState();
}

class _CheckInViewState extends State<_CheckInView> {
  String? _walkInPatientId;
  bool _showWalkInForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check In')),
      body: BlocBuilder<AppointmentListCubit, AppointmentListState>(
        builder: (context, state) {
          final appointments = state is AppointmentListLoaded
              ? state.appointments
                  .where((a) =>
                      a.status == AppointmentStatus.scheduled ||
                      a.status == AppointmentStatus.confirmed)
                  .toList()
              : <Appointment>[];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Scheduled Today',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                CheckInAppointmentList(
                  appointments: appointments,
                  onCheckIn: _checkInAppointment,
                ),
                const Divider(height: 32),
                Text('Walk-In',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (!_showWalkInForm)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Walk-In Patient'),
                    onPressed: () =>
                        setState(() => _showWalkInForm = true),
                  )
                else
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: WalkInFormWidget(
                        clinicId: widget.clinicId,
                        providerId: widget.providerId,
                        patientId: _walkInPatientId ?? '',
                        onSuccess: () {
                          setState(() => _showWalkInForm = false);
                          context.pop();
                        },
                        onCancel: () =>
                            setState(() => _showWalkInForm = false),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _checkInAppointment(Appointment appointment) async {
    final result = await sl<CheckInPatient>()(
      CheckInPatientParams(
        clinicId: widget.clinicId,
        patientId: appointment.patientId,
        providerId: appointment.providerId,
        appointmentId: appointment.id,
      ),
    );
    if (!mounted) return;
    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure.message)),
      ),
      (token) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${appointment.patientName ?? 'Patient'} checked in'),
            action: SnackBarAction(
              label: 'Record Triage',
              onPressed: () => context.pushNamed(
                RouteNames.queueTriage,
                pathParameters: {'tokenId': token.id},
              ),
            ),
          ),
        );
        context.pop();
      },
    );
  }
}
