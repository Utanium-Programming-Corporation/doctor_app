import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/appointment.dart';
import '../../domain/entities/appointment_status.dart';

part 'appointment_model.freezed.dart';
part 'appointment_model.g.dart';

class _AppointmentStatusConverter
    implements JsonConverter<AppointmentStatus, String> {
  const _AppointmentStatusConverter();

  @override
  AppointmentStatus fromJson(String json) =>
      AppointmentStatus.fromDbValue(json);

  @override
  String toJson(AppointmentStatus object) => object.toDbValue();
}

@freezed
abstract class AppointmentModel with _$AppointmentModel {
  const factory AppointmentModel({
    required String id,
    @JsonKey(name: 'clinic_id') required String clinicId,
    @JsonKey(name: 'patient_id') required String patientId,
    @JsonKey(name: 'provider_id') required String providerId,
    @JsonKey(name: 'appointment_type_id') required String appointmentTypeId,
    @JsonKey(name: 'location_id') String? locationId,
    @JsonKey(name: 'start_time') required DateTime startTime,
    @JsonKey(name: 'end_time') required DateTime endTime,
    @_AppointmentStatusConverter()
    @Default(AppointmentStatus.scheduled)
    AppointmentStatus status,
    @JsonKey(name: 'cancel_reason') String? cancelReason,
    String? notes,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Denormalized — populated from Supabase joins
    @JsonKey(includeToJson: false) String? patientName,
    @JsonKey(includeToJson: false) String? appointmentTypeName,
    @JsonKey(includeToJson: false) String? appointmentTypeColor,
    @JsonKey(includeToJson: false) String? providerName,
  }) = _AppointmentModel;

  /// Standard freezed fromJson — used by generated code.
  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);
}

extension AppointmentModelX on AppointmentModel {
  /// Parses from a Supabase join response that may contain nested objects
  /// (`patients`, `appointment_types`, `staff_assignments`).
  static AppointmentModel fromSupabaseJoin(Map<String, dynamic> json) {
    final patientFirst =
        (json['patients'] as Map<String, dynamic>?)?['first_name'] as String?;
    final patientLast =
        (json['patients'] as Map<String, dynamic>?)?['last_name'] as String?;
    final patientName = (patientFirst != null || patientLast != null)
        ? '${patientFirst ?? ''} ${patientLast ?? ''}'.trim()
        : null;

    final typeData = json['appointment_types'] as Map<String, dynamic>?;
    final typeName = typeData?['name'] as String?;
    final typeColor = typeData?['color_hex'] as String?;

    final staffData = json['staff_assignments'] as Map<String, dynamic>?;
    final resolvedProviderName = staffData?['user_name'] as String?;

    final flatJson = Map<String, dynamic>.from(json)
      ..['patientName'] = patientName
      ..['appointmentTypeName'] = typeName
      ..['appointmentTypeColor'] = typeColor
      ..['providerName'] = resolvedProviderName;

    return AppointmentModel.fromJson(flatJson);
  }

  Appointment toEntity() => Appointment(
        id: id,
        clinicId: clinicId,
        patientId: patientId,
        providerId: providerId,
        appointmentTypeId: appointmentTypeId,
        locationId: locationId,
        startTime: startTime,
        endTime: endTime,
        status: status,
        cancelReason: cancelReason,
        notes: notes,
        createdBy: createdBy,
        createdAt: createdAt,
        updatedAt: updatedAt,
        patientName: patientName,
        appointmentTypeName: appointmentTypeName,
        appointmentTypeColor: appointmentTypeColor,
        providerName: providerName,
      );
}
