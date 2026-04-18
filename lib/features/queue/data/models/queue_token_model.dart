import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/queue_priority.dart';
import '../../domain/entities/queue_token.dart';
import '../../domain/entities/queue_token_status.dart';

part 'queue_token_model.freezed.dart';
part 'queue_token_model.g.dart';

class _QueueTokenStatusConverter
    implements JsonConverter<QueueTokenStatus, String> {
  const _QueueTokenStatusConverter();

  @override
  QueueTokenStatus fromJson(String json) => QueueTokenStatus.fromDbValue(json);

  @override
  String toJson(QueueTokenStatus object) => object.toDbValue();
}

class _QueuePriorityConverter implements JsonConverter<QueuePriority, String> {
  const _QueuePriorityConverter();

  @override
  QueuePriority fromJson(String json) => QueuePriority.fromDbValue(json);

  @override
  String toJson(QueuePriority object) => object.toDbValue();
}

@freezed
abstract class QueueTokenModel with _$QueueTokenModel {
  const factory QueueTokenModel({
    required String id,
    @JsonKey(name: 'clinic_id') required String clinicId,
    @JsonKey(name: 'location_id') String? locationId,
    @JsonKey(name: 'token_number') required int tokenNumber,
    @JsonKey(name: 'patient_id') required String patientId,
    @JsonKey(name: 'appointment_id') String? appointmentId,
    @JsonKey(name: 'provider_id') required String providerId,
    @_QueueTokenStatusConverter()
    @Default(QueueTokenStatus.waiting)
    QueueTokenStatus status,
    @_QueuePriorityConverter()
    @Default(QueuePriority.normal)
    QueuePriority priority,
    @JsonKey(name: 'skip_count') @Default(0) int skipCount,
    @JsonKey(name: 'called_at') DateTime? calledAt,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    // Denormalized — populated from Supabase joins
    @JsonKey(includeToJson: false) String? patientName,
    @JsonKey(includeToJson: false) String? providerName,
  }) = _QueueTokenModel;

  factory QueueTokenModel.fromJson(Map<String, dynamic> json) =>
      _$QueueTokenModelFromJson(json);
}

extension QueueTokenModelX on QueueTokenModel {
  static QueueTokenModel fromSupabaseJoin(Map<String, dynamic> json) {
    final patientFirst =
        (json['patients'] as Map<String, dynamic>?)?['first_name'] as String?;
    final patientLast =
        (json['patients'] as Map<String, dynamic>?)?['last_name'] as String?;
    final patientName = (patientFirst != null || patientLast != null)
        ? '${patientFirst ?? ''} ${patientLast ?? ''}'.trim()
        : null;

    final profileData = json['profiles'] as Map<String, dynamic>?;
    final providerName = profileData?['full_name'] as String? ??
        profileData?['display_name'] as String?;

    final flatJson = Map<String, dynamic>.from(json)
      ..['patientName'] = patientName
      ..['providerName'] = providerName;

    return QueueTokenModel.fromJson(flatJson);
  }

  QueueToken toEntity() => QueueToken(
        id: id,
        clinicId: clinicId,
        locationId: locationId,
        tokenNumber: tokenNumber,
        patientId: patientId,
        appointmentId: appointmentId,
        providerId: providerId,
        status: status,
        priority: priority,
        skipCount: skipCount,
        calledAt: calledAt,
        startedAt: startedAt,
        completedAt: completedAt,
        createdAt: createdAt,
        patientName: patientName,
        providerName: providerName,
      );
}
