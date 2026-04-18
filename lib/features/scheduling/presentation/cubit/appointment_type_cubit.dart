import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/availability_params.dart';
import '../../domain/usecases/create_appointment_type.dart';
import '../../domain/usecases/get_appointment_types.dart';
import '../../domain/usecases/update_appointment_type.dart';
import 'appointment_type_state.dart';

class AppointmentTypeCubit extends Cubit<AppointmentTypeState> {
  final GetAppointmentTypes _getTypes;
  final CreateAppointmentType _createType;
  final UpdateAppointmentType _updateType;

  AppointmentTypeCubit({
    required GetAppointmentTypes getTypes,
    required CreateAppointmentType createType,
    required UpdateAppointmentType updateType,
  })  : _getTypes = getTypes,
        _createType = createType,
        _updateType = updateType,
        super(const AppointmentTypeInitial());

  Future<void> loadTypes(String clinicId) async {
    emit(const AppointmentTypeLoading());
    final result = await _getTypes(clinicId);
    result.fold(
      (failure) => emit(AppointmentTypeError(failure.message)),
      (types) => emit(AppointmentTypeLoaded(types: types)),
    );
  }

  Future<void> createType(CreateAppointmentTypeParams params) async {
    final current = state;
    if (current is! AppointmentTypeLoaded) return;
    emit(current.copyWith(isSaving: true));
    final result = await _createType(params);
    result.fold(
      (failure) => emit(current.copyWith(isSaving: false)),
      (created) => emit(current.copyWith(
        isSaving: false,
        types: [...current.types, created],
      )),
    );
  }

  Future<void> updateType(UpdateAppointmentTypeParams params) async {
    final current = state;
    if (current is! AppointmentTypeLoaded) return;
    emit(current.copyWith(isSaving: true));
    final result = await _updateType(params);
    result.fold(
      (failure) => emit(current.copyWith(isSaving: false)),
      (updated) => emit(current.copyWith(
        isSaving: false,
        types: current.types
            .map((t) => t.id == updated.id ? updated : t)
            .toList(),
      )),
    );
  }

  Future<void> toggleActive(String typeId, bool currentlyActive) async {
    final current = state;
    if (current is! AppointmentTypeLoaded) return;
    await updateType(
      UpdateAppointmentTypeParams(id: typeId, isActive: !currentlyActive),
    );
  }
}
