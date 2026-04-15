import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/route_names.dart';
import '../../../clinic/presentation/cubit/clinic_cubit.dart';
import '../../../clinic/presentation/cubit/clinic_state.dart';
import '../../domain/usecases/search_patients.dart';
import '../cubit/patient_list_cubit.dart';
import '../cubit/patient_list_state.dart';
import 'widgets/patient_list_tile.dart';
import 'widgets/patient_search_delegate.dart';

class PatientListPage extends StatelessWidget {
  const PatientListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<PatientListCubit>();
        final clinicState = context.read<ClinicCubit>().state;
        if (clinicState is ClinicLoaded &&
            clinicState.selectedClinicId != null) {
          cubit.loadPatients(clinicState.selectedClinicId!);
        }
        return cubit;
      },
      child: const _PatientListView(),
    );
  }
}

class _PatientListView extends StatefulWidget {
  const _PatientListView();

  @override
  State<_PatientListView> createState() => _PatientListViewState();
}

class _PatientListViewState extends State<_PatientListView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final clinicState = context.read<ClinicCubit>().state;
      if (clinicState is ClinicLoaded &&
          clinicState.selectedClinicId != null) {
        context.read<PatientListCubit>().loadMore(clinicState.selectedClinicId!);
      }
    }
  }

  void _onSearch(String query) {
    final clinicState = context.read<ClinicCubit>().state;
    if (clinicState is ClinicLoaded && clinicState.selectedClinicId != null) {
      context
          .read<PatientListCubit>()
          .searchPatientsInClinic(clinicState.selectedClinicId!, query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final clinicState = context.read<ClinicCubit>().state;
              if (clinicState is ClinicLoaded &&
                  clinicState.selectedClinicId != null) {
                showSearch<void>(
                  context: context,
                  delegate: PatientSearchDelegate(
                    searchPatients: sl<SearchPatients>(),
                    clinicId: clinicState.selectedClinicId!,
                  ),
                );
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by name, phone, ID…',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearch,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(RouteNames.patientNew),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<PatientListCubit, PatientListState>(
        builder: (context, state) {
          if (state is PatientListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PatientListError) {
            return Center(child: Text(state.message));
          }
          if (state is PatientListLoaded) {
            if (state.patients.isEmpty) {
              return const Center(
                child: Text('No patients yet. Tap + to register your first patient.'),
              );
            }
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.patients.length,
              itemBuilder: (context, index) {
                final patient = state.patients[index];
                return PatientListTile(
                  patient: patient,
                  onTap: () => context.pushNamed(
                    RouteNames.patientDetail,
                    pathParameters: {'id': patient.id},
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
