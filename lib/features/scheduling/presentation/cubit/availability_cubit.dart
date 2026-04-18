import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/provider_availability.dart';
import '../../domain/repositories/availability_params.dart';
import '../../domain/usecases/add_blocked_date.dart';
import '../../domain/usecases/get_provider_availability.dart';
import '../../domain/usecases/remove_blocked_date.dart';
import '../../domain/usecases/set_provider_availability.dart';
import 'availability_state.dart';

class AvailabilityCubit extends Cubit<AvailabilityState> {
  final GetProviderAvailability _getAvailability;
  final SetProviderAvailability _setAvailability;
  final AddBlockedDate _addBlockedDate;
  final RemoveBlockedDate _removeBlockedDate;

  AvailabilityCubit({
    required GetProviderAvailability getAvailability,
    required SetProviderAvailability setAvailability,
    required AddBlockedDate addBlockedDate,
    required RemoveBlockedDate removeBlockedDate,
  })  : _getAvailability = getAvailability,
        _setAvailability = setAvailability,
        _addBlockedDate = addBlockedDate,
        _removeBlockedDate = removeBlockedDate,
        super(const AvailabilityInitial());

  Future<void> loadAvailability({
    required String clinicId,
    required String providerId,
  }) async {
    emit(const AvailabilityLoading());
    final result = await _getAvailability(
      GetProviderAvailabilityParams(
        clinicId: clinicId,
        providerId: providerId,
      ),
    );
    result.fold(
      (failure) => emit(AvailabilityError(failure.message)),
      (entries) {
        final grouped = <int, List<ProviderAvailability>>{};
        for (final e in entries) {
          grouped.putIfAbsent(e.dayOfWeek, () => []).add(e);
        }
        emit(AvailabilityLoaded(
          weeklyEntries: grouped,
          providerId: providerId,
        ));
      },
    );
  }

  Future<void> saveAll({
    required String clinicId,
    required List<AvailabilityEntry> entries,
  }) async {
    final current = state;
    if (current is! AvailabilityLoaded) return;
    emit(current.copyWith(isSaving: true));
    final result = await _setAvailability(
      SetProviderAvailabilityParams(
        clinicId: clinicId,
        providerId: current.providerId,
        entries: entries,
      ),
    );
    result.fold(
      (failure) => emit(current.copyWith(isSaving: false)),
      (updated) {
        final grouped = <int, List<ProviderAvailability>>{};
        for (final e in updated) {
          grouped.putIfAbsent(e.dayOfWeek, () => []).add(e);
        }
        emit(current.copyWith(
          isSaving: false,
          weeklyEntries: grouped,
        ));
      },
    );
  }

  Future<void> addBlockedDate({
    required String clinicId,
    required DateTime date,
    String? reason,
  }) async {
    final current = state;
    if (current is! AvailabilityLoaded) return;
    emit(current.copyWith(isSaving: true));
    final result = await _addBlockedDate(
      AddBlockedDateParams(
        clinicId: clinicId,
        providerId: current.providerId,
        blockedDate: date,
        reason: reason,
      ),
    );
    result.fold(
      (failure) => emit(current.copyWith(isSaving: false)),
      (blocked) => emit(current.copyWith(
        isSaving: false,
        blockedDates: [...current.blockedDates, blocked],
      )),
    );
  }

  Future<void> removeBlockedDate(String id) async {
    final current = state;
    if (current is! AvailabilityLoaded) return;
    emit(current.copyWith(isSaving: true));
    final result = await _removeBlockedDate(id);
    result.fold(
      (failure) => emit(current.copyWith(isSaving: false)),
      (_) => emit(current.copyWith(
        isSaving: false,
        blockedDates:
            current.blockedDates.where((b) => b.id != id).toList(),
      )),
    );
  }
}
