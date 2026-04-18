import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/blocked_date.dart';

part 'blocked_date_model.freezed.dart';
part 'blocked_date_model.g.dart';

@freezed
abstract class BlockedDateModel with _$BlockedDateModel {
  const factory BlockedDateModel({
    required String id,
    @JsonKey(name: 'clinic_id') required String clinicId,
    @JsonKey(name: 'provider_id') required String providerId,
    @JsonKey(name: 'blocked_date') required DateTime blockedDate,
    String? reason,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _BlockedDateModel;

  factory BlockedDateModel.fromJson(Map<String, dynamic> json) =>
      _$BlockedDateModelFromJson(json);
}

extension BlockedDateModelX on BlockedDateModel {
  BlockedDate toEntity() => BlockedDate(
        id: id,
        clinicId: clinicId,
        providerId: providerId,
        blockedDate: blockedDate,
        reason: reason,
        createdAt: createdAt,
      );
}
