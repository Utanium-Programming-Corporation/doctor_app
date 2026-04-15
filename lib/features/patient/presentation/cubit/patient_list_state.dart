import '../../domain/entities/patient.dart';

sealed class PatientListState {
  const PatientListState();
}

class PatientListInitial extends PatientListState {
  const PatientListInitial();
}

class PatientListLoading extends PatientListState {
  const PatientListLoading();
}

class PatientListLoaded extends PatientListState {
  final List<Patient> patients;
  final int page;
  final bool hasMore;
  final String? searchQuery;

  const PatientListLoaded({
    required this.patients,
    required this.page,
    required this.hasMore,
    this.searchQuery,
  });

  PatientListLoaded copyWith({
    List<Patient>? patients,
    int? page,
    bool? hasMore,
    String? searchQuery,
    bool clearSearchQuery = false,
  }) {
    return PatientListLoaded(
      patients: patients ?? this.patients,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
    );
  }
}

class PatientListError extends PatientListState {
  final String message;

  const PatientListError(this.message);
}
