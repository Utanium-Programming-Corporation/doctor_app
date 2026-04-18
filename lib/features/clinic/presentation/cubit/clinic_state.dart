import '../../domain/entities/clinic.dart';
import '../../domain/entities/staff_assignment.dart';

sealed class ClinicState {
  const ClinicState();
}

class ClinicInitial extends ClinicState {
  const ClinicInitial();
}

class ClinicLoading extends ClinicState {
  const ClinicLoading();
}

class ClinicLoaded extends ClinicState {
  final List<StaffAssignment> assignments;
  final String? selectedClinicId;
  final Clinic? selectedClinic;
  final List<StaffAssignment>? staff;

  const ClinicLoaded({
    required this.assignments,
    this.selectedClinicId,
    this.selectedClinic,
    this.staff,
  });

  ClinicLoaded copyWith({
    List<StaffAssignment>? assignments,
    String? selectedClinicId,
    Clinic? selectedClinic,
    List<StaffAssignment>? staff,
    bool clearSelectedClinic = false,
    bool clearStaff = false,
  }) {
    return ClinicLoaded(
      assignments: assignments ?? this.assignments,
      selectedClinicId: selectedClinicId ?? this.selectedClinicId,
      selectedClinic:
          clearSelectedClinic ? null : (selectedClinic ?? this.selectedClinic),
      staff: clearStaff ? null : (staff ?? this.staff),
    );
  }
}

class ClinicError extends ClinicState {
  final String message;

  const ClinicError(this.message);
}
