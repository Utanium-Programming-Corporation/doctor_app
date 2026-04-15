// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'triage_assessment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TriageAssessmentModel {

 String get id;@JsonKey(name: 'queue_token_id') String get queueTokenId;@JsonKey(name: 'clinic_id') String get clinicId;@JsonKey(name: 'blood_pressure_systolic') int? get bloodPressureSystolic;@JsonKey(name: 'blood_pressure_diastolic') int? get bloodPressureDiastolic;@JsonKey(name: 'heart_rate') int? get heartRate; double? get temperature; double? get weight; int? get spo2;@JsonKey(name: 'chief_complaint') String? get chiefComplaint;@JsonKey(name: 'recorded_by') String get recordedBy;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of TriageAssessmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriageAssessmentModelCopyWith<TriageAssessmentModel> get copyWith => _$TriageAssessmentModelCopyWithImpl<TriageAssessmentModel>(this as TriageAssessmentModel, _$identity);

  /// Serializes this TriageAssessmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriageAssessmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.queueTokenId, queueTokenId) || other.queueTokenId == queueTokenId)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.bloodPressureSystolic, bloodPressureSystolic) || other.bloodPressureSystolic == bloodPressureSystolic)&&(identical(other.bloodPressureDiastolic, bloodPressureDiastolic) || other.bloodPressureDiastolic == bloodPressureDiastolic)&&(identical(other.heartRate, heartRate) || other.heartRate == heartRate)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.spo2, spo2) || other.spo2 == spo2)&&(identical(other.chiefComplaint, chiefComplaint) || other.chiefComplaint == chiefComplaint)&&(identical(other.recordedBy, recordedBy) || other.recordedBy == recordedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,queueTokenId,clinicId,bloodPressureSystolic,bloodPressureDiastolic,heartRate,temperature,weight,spo2,chiefComplaint,recordedBy,createdAt);

@override
String toString() {
  return 'TriageAssessmentModel(id: $id, queueTokenId: $queueTokenId, clinicId: $clinicId, bloodPressureSystolic: $bloodPressureSystolic, bloodPressureDiastolic: $bloodPressureDiastolic, heartRate: $heartRate, temperature: $temperature, weight: $weight, spo2: $spo2, chiefComplaint: $chiefComplaint, recordedBy: $recordedBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TriageAssessmentModelCopyWith<$Res>  {
  factory $TriageAssessmentModelCopyWith(TriageAssessmentModel value, $Res Function(TriageAssessmentModel) _then) = _$TriageAssessmentModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'queue_token_id') String queueTokenId,@JsonKey(name: 'clinic_id') String clinicId,@JsonKey(name: 'blood_pressure_systolic') int? bloodPressureSystolic,@JsonKey(name: 'blood_pressure_diastolic') int? bloodPressureDiastolic,@JsonKey(name: 'heart_rate') int? heartRate, double? temperature, double? weight, int? spo2,@JsonKey(name: 'chief_complaint') String? chiefComplaint,@JsonKey(name: 'recorded_by') String recordedBy,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$TriageAssessmentModelCopyWithImpl<$Res>
    implements $TriageAssessmentModelCopyWith<$Res> {
  _$TriageAssessmentModelCopyWithImpl(this._self, this._then);

  final TriageAssessmentModel _self;
  final $Res Function(TriageAssessmentModel) _then;

/// Create a copy of TriageAssessmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? queueTokenId = null,Object? clinicId = null,Object? bloodPressureSystolic = freezed,Object? bloodPressureDiastolic = freezed,Object? heartRate = freezed,Object? temperature = freezed,Object? weight = freezed,Object? spo2 = freezed,Object? chiefComplaint = freezed,Object? recordedBy = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,queueTokenId: null == queueTokenId ? _self.queueTokenId : queueTokenId // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,bloodPressureSystolic: freezed == bloodPressureSystolic ? _self.bloodPressureSystolic : bloodPressureSystolic // ignore: cast_nullable_to_non_nullable
as int?,bloodPressureDiastolic: freezed == bloodPressureDiastolic ? _self.bloodPressureDiastolic : bloodPressureDiastolic // ignore: cast_nullable_to_non_nullable
as int?,heartRate: freezed == heartRate ? _self.heartRate : heartRate // ignore: cast_nullable_to_non_nullable
as int?,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,spo2: freezed == spo2 ? _self.spo2 : spo2 // ignore: cast_nullable_to_non_nullable
as int?,chiefComplaint: freezed == chiefComplaint ? _self.chiefComplaint : chiefComplaint // ignore: cast_nullable_to_non_nullable
as String?,recordedBy: null == recordedBy ? _self.recordedBy : recordedBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TriageAssessmentModel].
extension TriageAssessmentModelPatterns on TriageAssessmentModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TriageAssessmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriageAssessmentModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TriageAssessmentModel value)  $default,){
final _that = this;
switch (_that) {
case _TriageAssessmentModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TriageAssessmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _TriageAssessmentModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'queue_token_id')  String queueTokenId, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'blood_pressure_systolic')  int? bloodPressureSystolic, @JsonKey(name: 'blood_pressure_diastolic')  int? bloodPressureDiastolic, @JsonKey(name: 'heart_rate')  int? heartRate,  double? temperature,  double? weight,  int? spo2, @JsonKey(name: 'chief_complaint')  String? chiefComplaint, @JsonKey(name: 'recorded_by')  String recordedBy, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriageAssessmentModel() when $default != null:
return $default(_that.id,_that.queueTokenId,_that.clinicId,_that.bloodPressureSystolic,_that.bloodPressureDiastolic,_that.heartRate,_that.temperature,_that.weight,_that.spo2,_that.chiefComplaint,_that.recordedBy,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'queue_token_id')  String queueTokenId, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'blood_pressure_systolic')  int? bloodPressureSystolic, @JsonKey(name: 'blood_pressure_diastolic')  int? bloodPressureDiastolic, @JsonKey(name: 'heart_rate')  int? heartRate,  double? temperature,  double? weight,  int? spo2, @JsonKey(name: 'chief_complaint')  String? chiefComplaint, @JsonKey(name: 'recorded_by')  String recordedBy, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _TriageAssessmentModel():
return $default(_that.id,_that.queueTokenId,_that.clinicId,_that.bloodPressureSystolic,_that.bloodPressureDiastolic,_that.heartRate,_that.temperature,_that.weight,_that.spo2,_that.chiefComplaint,_that.recordedBy,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'queue_token_id')  String queueTokenId, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'blood_pressure_systolic')  int? bloodPressureSystolic, @JsonKey(name: 'blood_pressure_diastolic')  int? bloodPressureDiastolic, @JsonKey(name: 'heart_rate')  int? heartRate,  double? temperature,  double? weight,  int? spo2, @JsonKey(name: 'chief_complaint')  String? chiefComplaint, @JsonKey(name: 'recorded_by')  String recordedBy, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TriageAssessmentModel() when $default != null:
return $default(_that.id,_that.queueTokenId,_that.clinicId,_that.bloodPressureSystolic,_that.bloodPressureDiastolic,_that.heartRate,_that.temperature,_that.weight,_that.spo2,_that.chiefComplaint,_that.recordedBy,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TriageAssessmentModel implements TriageAssessmentModel {
  const _TriageAssessmentModel({required this.id, @JsonKey(name: 'queue_token_id') required this.queueTokenId, @JsonKey(name: 'clinic_id') required this.clinicId, @JsonKey(name: 'blood_pressure_systolic') this.bloodPressureSystolic, @JsonKey(name: 'blood_pressure_diastolic') this.bloodPressureDiastolic, @JsonKey(name: 'heart_rate') this.heartRate, this.temperature, this.weight, this.spo2, @JsonKey(name: 'chief_complaint') this.chiefComplaint, @JsonKey(name: 'recorded_by') required this.recordedBy, @JsonKey(name: 'created_at') required this.createdAt});
  factory _TriageAssessmentModel.fromJson(Map<String, dynamic> json) => _$TriageAssessmentModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'queue_token_id') final  String queueTokenId;
@override@JsonKey(name: 'clinic_id') final  String clinicId;
@override@JsonKey(name: 'blood_pressure_systolic') final  int? bloodPressureSystolic;
@override@JsonKey(name: 'blood_pressure_diastolic') final  int? bloodPressureDiastolic;
@override@JsonKey(name: 'heart_rate') final  int? heartRate;
@override final  double? temperature;
@override final  double? weight;
@override final  int? spo2;
@override@JsonKey(name: 'chief_complaint') final  String? chiefComplaint;
@override@JsonKey(name: 'recorded_by') final  String recordedBy;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of TriageAssessmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriageAssessmentModelCopyWith<_TriageAssessmentModel> get copyWith => __$TriageAssessmentModelCopyWithImpl<_TriageAssessmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TriageAssessmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriageAssessmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.queueTokenId, queueTokenId) || other.queueTokenId == queueTokenId)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.bloodPressureSystolic, bloodPressureSystolic) || other.bloodPressureSystolic == bloodPressureSystolic)&&(identical(other.bloodPressureDiastolic, bloodPressureDiastolic) || other.bloodPressureDiastolic == bloodPressureDiastolic)&&(identical(other.heartRate, heartRate) || other.heartRate == heartRate)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.spo2, spo2) || other.spo2 == spo2)&&(identical(other.chiefComplaint, chiefComplaint) || other.chiefComplaint == chiefComplaint)&&(identical(other.recordedBy, recordedBy) || other.recordedBy == recordedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,queueTokenId,clinicId,bloodPressureSystolic,bloodPressureDiastolic,heartRate,temperature,weight,spo2,chiefComplaint,recordedBy,createdAt);

@override
String toString() {
  return 'TriageAssessmentModel(id: $id, queueTokenId: $queueTokenId, clinicId: $clinicId, bloodPressureSystolic: $bloodPressureSystolic, bloodPressureDiastolic: $bloodPressureDiastolic, heartRate: $heartRate, temperature: $temperature, weight: $weight, spo2: $spo2, chiefComplaint: $chiefComplaint, recordedBy: $recordedBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TriageAssessmentModelCopyWith<$Res> implements $TriageAssessmentModelCopyWith<$Res> {
  factory _$TriageAssessmentModelCopyWith(_TriageAssessmentModel value, $Res Function(_TriageAssessmentModel) _then) = __$TriageAssessmentModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'queue_token_id') String queueTokenId,@JsonKey(name: 'clinic_id') String clinicId,@JsonKey(name: 'blood_pressure_systolic') int? bloodPressureSystolic,@JsonKey(name: 'blood_pressure_diastolic') int? bloodPressureDiastolic,@JsonKey(name: 'heart_rate') int? heartRate, double? temperature, double? weight, int? spo2,@JsonKey(name: 'chief_complaint') String? chiefComplaint,@JsonKey(name: 'recorded_by') String recordedBy,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$TriageAssessmentModelCopyWithImpl<$Res>
    implements _$TriageAssessmentModelCopyWith<$Res> {
  __$TriageAssessmentModelCopyWithImpl(this._self, this._then);

  final _TriageAssessmentModel _self;
  final $Res Function(_TriageAssessmentModel) _then;

/// Create a copy of TriageAssessmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? queueTokenId = null,Object? clinicId = null,Object? bloodPressureSystolic = freezed,Object? bloodPressureDiastolic = freezed,Object? heartRate = freezed,Object? temperature = freezed,Object? weight = freezed,Object? spo2 = freezed,Object? chiefComplaint = freezed,Object? recordedBy = null,Object? createdAt = null,}) {
  return _then(_TriageAssessmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,queueTokenId: null == queueTokenId ? _self.queueTokenId : queueTokenId // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,bloodPressureSystolic: freezed == bloodPressureSystolic ? _self.bloodPressureSystolic : bloodPressureSystolic // ignore: cast_nullable_to_non_nullable
as int?,bloodPressureDiastolic: freezed == bloodPressureDiastolic ? _self.bloodPressureDiastolic : bloodPressureDiastolic // ignore: cast_nullable_to_non_nullable
as int?,heartRate: freezed == heartRate ? _self.heartRate : heartRate // ignore: cast_nullable_to_non_nullable
as int?,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,spo2: freezed == spo2 ? _self.spo2 : spo2 // ignore: cast_nullable_to_non_nullable
as int?,chiefComplaint: freezed == chiefComplaint ? _self.chiefComplaint : chiefComplaint // ignore: cast_nullable_to_non_nullable
as String?,recordedBy: null == recordedBy ? _self.recordedBy : recordedBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
