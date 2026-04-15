import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/route_names.dart';
import '../../../clinic/domain/entities/staff_assignment.dart';
import '../../../clinic/presentation/cubit/clinic_cubit.dart';
import '../../../clinic/presentation/cubit/clinic_state.dart';
import '../cubit/appointment_list_cubit.dart';
import '../cubit/appointment_list_state.dart';
import 'widgets/appointment_list_tile.dart';
import 'widgets/date_provider_filter_bar.dart';

class AppointmentListPage extends StatelessWidget {
  const AppointmentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final clinicState = context.read<ClinicCubit>().state;
    final clinicId = clinicState is ClinicLoaded
        ? (clinicState.selectedClinicId ?? '')
        : '';

    return BlocProvider(
      create: (_) {
        final cubit = sl<AppointmentListCubit>();
        if (clinicId.isNotEmpty) {
          cubit.loadAppointments(
            clinicId: clinicId,
            date: DateTime.now(),
          );
        }
        return cubit;
      },
      child: _AppointmentListView(clinicId: clinicId),
    );
  }
}

class _AppointmentListView extends StatelessWidget {
  final String clinicId;

  const _AppointmentListView({required this.clinicId});

  @override
  Widget build(BuildContext context) {
    final clinicState = context.watch<ClinicCubit>().state;
    final staff = clinicState is ClinicLoaded
        ? (clinicState.staff ?? <StaffAssignment>[])
        : <StaffAssignment>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.pushNamed(RouteNames.bookAppointment),
          ),
        ],
      ),
      body: BlocBuilder<AppointmentListCubit, AppointmentListState>(
        builder: (context, state) {
          final selectedDate = state is AppointmentListLoaded
              ? state.selectedDate
              : DateTime.now();
          final selectedProviderId =
              state is AppointmentListLoaded ? state.selectedProviderId : null;

          return Column(
            children: [
              DateProviderFilterBar(
                selectedDate: selectedDate,
                selectedProviderId: selectedProviderId,
                staff: staff,
                onDateChanged: (date) => context
                    .read<AppointmentListCubit>()
                    .changeDate(clinicId: clinicId, date: date),
                onProviderChanged: (providerId) => context
                    .read<AppointmentListCubit>()
                    .filterByProvider(
                        clinicId: clinicId, providerId: providerId),
              ),
              Expanded(
                child: switch (state) {
                  AppointmentListInitial() ||
                  AppointmentListLoading() =>
                    const Center(child: CircularProgressIndicator()),
                  AppointmentListError(:final message) =>
                    Center(child: Text(message)),
                  AppointmentListLoaded(:final appointments) =>
                    appointments.isEmpty
                        ? const Center(
                            child: Text('No appointments for this day.'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: appointments.length,
                            itemBuilder: (context, index) {
                              final appt = appointments[index];
                              return AppointmentListTile(
                                appointment: appt,
                                onTap: () => context.pushNamed(
                                  RouteNames.appointmentDetail,
                                  pathParameters: {'id': appt.id},
                                ),
                              );
                            },
                          ),
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
