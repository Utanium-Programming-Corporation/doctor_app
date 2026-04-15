import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/check_in_patient.dart';
import 'walk_in_state.dart';

class WalkInCubit extends Cubit<WalkInState> {
  final CheckInPatient _checkInPatient;

  WalkInCubit({required CheckInPatient checkInPatient})
      : _checkInPatient = checkInPatient,
        super(const WalkInInitial());

  Future<void> checkIn(CheckInPatientParams params) async {
    emit(const WalkInLoading());
    final result = await _checkInPatient(params);
    result.fold(
      (failure) => emit(WalkInError(failure.message)),
      (_) => emit(const WalkInSuccess()),
    );
  }
}
