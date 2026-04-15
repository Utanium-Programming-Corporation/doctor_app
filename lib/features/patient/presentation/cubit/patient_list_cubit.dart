import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/patient_repository.dart';
import '../../domain/usecases/get_patients_list.dart';
import '../../domain/usecases/search_patients.dart';
import 'patient_list_state.dart';

class PatientListCubit extends Cubit<PatientListState> {
  final GetPatientsList _getPatientsList;
  final SearchPatients _searchPatients;
  static const int _pageSize = 20;

  PatientListCubit({
    required GetPatientsList getPatientsList,
    required SearchPatients searchPatients,
  })  : _getPatientsList = getPatientsList,
        _searchPatients = searchPatients,
        super(const PatientListInitial());

  Future<void> loadPatients(String clinicId) async {
    emit(const PatientListLoading());
    final result = await _getPatientsList(
      GetPatientsListParams(clinicId: clinicId, page: 0),
    );
    result.fold(
      (failure) => emit(PatientListError(failure.message)),
      (patients) => emit(PatientListLoaded(
        patients: patients,
        page: 0,
        hasMore: patients.length == _pageSize,
      )),
    );
  }

  Future<void> loadMore(String clinicId) async {
    final current = state;
    if (current is! PatientListLoaded || !current.hasMore) return;
    final nextPage = current.page + 1;
    final result = await _getPatientsList(
      GetPatientsListParams(clinicId: clinicId, page: nextPage),
    );
    result.fold(
      (failure) => emit(PatientListError(failure.message)),
      (newPatients) => emit(current.copyWith(
        patients: [...current.patients, ...newPatients],
        page: nextPage,
        hasMore: newPatients.length == _pageSize,
      )),
    );
  }

  Future<void> searchPatientsInClinic(String clinicId, String query) async {
    if (query.trim().isEmpty) {
      await loadPatients(clinicId);
      return;
    }
    emit(const PatientListLoading());
    final result = await _searchPatients(
      SearchPatientsParams(clinicId: clinicId, query: query),
    );
    result.fold(
      (failure) => emit(PatientListError(failure.message)),
      (patients) => emit(PatientListLoaded(
        patients: patients,
        page: 0,
        hasMore: false,
        searchQuery: query,
      )),
    );
  }
}
