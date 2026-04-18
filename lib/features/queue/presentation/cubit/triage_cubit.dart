import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/triage_usecases.dart';
import 'triage_state.dart';

class TriageCubit extends Cubit<TriageState> {
  final RecordTriage _recordTriage;
  final GetTriageForToken _getTriageForToken;

  TriageCubit({
    required RecordTriage recordTriage,
    required GetTriageForToken getTriageForToken,
  })  : _recordTriage = recordTriage,
        _getTriageForToken = getTriageForToken,
        super(const TriageInitial());

  Future<void> recordTriage(RecordTriageParams params) async {
    emit(const TriageLoading());
    final result = await _recordTriage(params);
    result.fold(
      (failure) => emit(TriageError(failure.message)),
      (assessment) => emit(TriageSaved(assessment)),
    );
  }

  Future<void> loadTriage(String queueTokenId) async {
    emit(const TriageLoading());
    final result = await _getTriageForToken(queueTokenId);
    result.fold(
      (failure) => emit(TriageError(failure.message)),
      (assessment) => emit(TriageLoaded(assessment)),
    );
  }
}
