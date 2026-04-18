import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/patient_repository.dart';
import '../../domain/usecases/create_patient.dart';
import '../../domain/usecases/deactivate_patient.dart';
import '../../domain/usecases/get_patient_by_id.dart';
import '../../domain/usecases/update_patient.dart';
import 'patient_detail_state.dart';

class PatientDetailCubit extends Cubit<PatientDetailState> {
  final CreatePatient _createPatient;
  final UpdatePatient _updatePatient;
  final GetPatientById _getPatientById;
  final DeactivatePatient _deactivatePatient;

  PatientDetailCubit({
    required CreatePatient createPatient,
    required UpdatePatient updatePatient,
    required GetPatientById getPatientById,
    required DeactivatePatient deactivatePatient,
  })  : _createPatient = createPatient,
        _updatePatient = updatePatient,
        _getPatientById = getPatientById,
        _deactivatePatient = deactivatePatient,
        super(const PatientDetailInitial());

  Future<void> loadPatient(String id) async {
    emit(const PatientDetailLoading());
    final result = await _getPatientById(id);
    result.fold(
      (failure) => emit(PatientDetailError(failure.message)),
      (patient) => emit(PatientDetailLoaded(patient)),
    );
  }

  Future<void> createPatient(CreatePatientParams params) async {
    emit(const PatientDetailLoading());
    final result = await _createPatient(params);
    result.fold(
      (failure) => emit(PatientDetailError(failure.message)),
      (patient) => emit(PatientDetailSaved(patient)),
    );
  }

  Future<void> updatePatient(UpdatePatientParams params) async {
    emit(const PatientDetailLoading());
    final result = await _updatePatient(params);
    result.fold(
      (failure) => emit(PatientDetailError(failure.message)),
      (patient) => emit(PatientDetailSaved(patient)),
    );
  }

  Future<void> deactivatePatient(String id) async {
    emit(const PatientDetailLoading());
    final result = await _deactivatePatient(id);
    result.fold(
      (failure) => emit(PatientDetailError(failure.message)),
      (_) => emit(const PatientDetailInitial()),
    );
  }
}
