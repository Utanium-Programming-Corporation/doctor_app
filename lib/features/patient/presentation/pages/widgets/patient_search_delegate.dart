import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/route_names.dart';
import '../../../domain/entities/patient.dart';
import '../../../domain/repositories/patient_repository.dart';
import '../../../domain/usecases/search_patients.dart';

class PatientSearchDelegate extends SearchDelegate<Patient?> {
  final SearchPatients _searchPatients;
  final String clinicId;

  PatientSearchDelegate({
    required SearchPatients searchPatients,
    required this.clinicId,
  }) : _searchPatients = searchPatients;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _SearchResultsWidget(
      searchPatients: _searchPatients,
      clinicId: clinicId,
      query: query,
      onTap: (patient) => close(context, patient),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length < 2) {
      return const Center(child: Text('Type at least 2 characters'));
    }
    return _SearchResultsWidget(
      searchPatients: _searchPatients,
      clinicId: clinicId,
      query: query,
      onTap: (patient) => close(context, patient),
    );
  }
}

class _SearchResultsWidget extends StatefulWidget {
  final SearchPatients searchPatients;
  final String clinicId;
  final String query;
  final void Function(Patient) onTap;

  const _SearchResultsWidget({
    required this.searchPatients,
    required this.clinicId,
    required this.query,
    required this.onTap,
  });

  @override
  State<_SearchResultsWidget> createState() => _SearchResultsWidgetState();
}

class _SearchResultsWidgetState extends State<_SearchResultsWidget> {
  late Future<List<Patient>> _future;

  @override
  void initState() {
    super.initState();
    _future = _doSearch();
  }

  @override
  void didUpdateWidget(_SearchResultsWidget old) {
    super.didUpdateWidget(old);
    if (old.query != widget.query) {
      setState(() => _future = _doSearch());
    }
  }

  Future<List<Patient>> _doSearch() async {
    final result = await widget.searchPatients(
      SearchPatientsParams(clinicId: widget.clinicId, query: widget.query),
    );
    return result.fold((_) => [], (patients) => patients);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Patient>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final patients = snapshot.data ?? [];
        if (patients.isEmpty) {
          return const Center(child: Text('No patients found'));
        }
        return ListView.builder(
          itemCount: patients.length,
          itemBuilder: (context, index) {
            final patient = patients[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(
                  patient.firstName.isNotEmpty
                      ? patient.firstName[0].toUpperCase()
                      : '?',
                ),
              ),
              title: Text(patient.fullName),
              subtitle: Text(patient.phoneNumber),
              onTap: () {
                widget.onTap(patient);
                context.pushNamed(
                  RouteNames.patientDetail,
                  pathParameters: {'id': patient.id},
                );
              },
            );
          },
        );
      },
    );
  }
}
