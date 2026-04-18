import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/route_names.dart';
import '../cubit/patient_detail_cubit.dart';
import '../cubit/patient_detail_state.dart';
import 'widgets/coming_soon_tab.dart';
import 'widgets/patient_info_section.dart';

class PatientDetailPage extends StatelessWidget {
  final String patientId;

  const PatientDetailPage({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PatientDetailCubit>()..loadPatient(patientId),
      child: _PatientDetailView(patientId: patientId),
    );
  }
}

class _PatientDetailView extends StatelessWidget {
  final String patientId;

  const _PatientDetailView({required this.patientId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientDetailCubit, PatientDetailState>(
      listener: (context, state) {
        if (state is PatientDetailInitial) {
          context.pop();
        }
      },
      builder: (context, state) {
        if (state is PatientDetailLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is PatientDetailError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(state.message)),
          );
        }
        if (state is PatientDetailLoaded || state is PatientDetailSaved) {
          final patient = state is PatientDetailLoaded
              ? state.patient
              : (state as PatientDetailSaved).patient;
          return DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                title: Text(patient.fullName),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => context.pushNamed(
                      RouteNames.patientEdit,
                      pathParameters: {'id': patient.id},
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'deactivate') {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Deactivate Patient'),
                            content: const Text(
                              'Are you sure? This patient will be removed from the active list.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Deactivate'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true && context.mounted) {
                          context
                              .read<PatientDetailCubit>()
                              .deactivatePatient(patient.id);
                        }
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'deactivate',
                        child: Text('Deactivate'),
                      ),
                    ],
                  ),
                ],
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Info'),
                    Tab(text: 'Appointments'),
                    Tab(text: 'Medical'),
                    Tab(text: 'Billing'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  PatientInfoSection(patient: patient),
                  const ComingSoonTab(),
                  const ComingSoonTab(),
                  const ComingSoonTab(),
                ],
              ),
            ),
          );
        }
        return const Scaffold(body: SizedBox.shrink());
      },
    );
  }
}
