import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/route_names.dart';
import '../../../clinic/presentation/cubit/clinic_cubit.dart';
import '../../../clinic/presentation/cubit/clinic_state.dart';
import '../cubit/my_day_cubit.dart';
import '../cubit/my_day_state.dart';
import 'widgets/appointment_list_tile.dart';

class MyDayPage extends StatelessWidget {
  const MyDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final clinicState = context.read<ClinicCubit>().state;
    final clinicId = clinicState is ClinicLoaded
        ? (clinicState.selectedClinicId ?? '')
        : '';
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';

    return BlocProvider(
      create: (_) {
        final cubit = sl<MyDayCubit>();
        if (clinicId.isNotEmpty && userId.isNotEmpty) {
          cubit.loadMyDay(clinicId: clinicId, providerId: userId);
        }
        return cubit;
      },
      child: _MyDayView(clinicId: clinicId),
    );
  }
}

class _MyDayView extends StatelessWidget {
  final String clinicId;

  const _MyDayView({required this.clinicId});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Day — ${today.day}/${today.month}/${today.year}',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<MyDayCubit>().refresh(clinicId: clinicId),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.pushNamed(RouteNames.bookAppointment),
          ),
        ],
      ),
      body: BlocBuilder<MyDayCubit, MyDayState>(
        builder: (context, state) {
          return switch (state) {
            MyDayInitial() ||
            MyDayLoading() =>
              const Center(child: CircularProgressIndicator()),
            MyDayError(:final message) => Center(child: Text(message)),
            MyDayLoaded(:final appointments) => appointments.isEmpty
                ? const Center(
                    child: Text('No appointments scheduled for today.'),
                  )
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
          };
        },
      ),
    );
  }
}
