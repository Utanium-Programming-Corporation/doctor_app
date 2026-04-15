// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_token_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueueTokenModel {

 String get id;@JsonKey(name: 'clinic_id') String get clinicId;@JsonKey(name: 'location_id') String? get locationId;@JsonKey(name: 'token_number') int get tokenNumber;@JsonKey(name: 'patient_id') String get patientId;@JsonKey(name: 'appointment_id') String? get appointmentId;@JsonKey(name: 'provider_id') String get providerId;@_QueueTokenStatusConverter() QueueTokenStatus get status;@_QueuePriorityConverter() QueuePriority get priority;@JsonKey(name: 'skip_count') int get skipCount;@JsonKey(name: 'called_at') DateTime? get calledAt;@JsonKey(name: 'started_at') DateTime? get startedAt;@JsonKey(name: 'completed_at') DateTime? get completedAt;@JsonKey(name: 'created_at') DateTime get createdAt;// Denormalized — populated from Supabase joins
@JsonKey(includeToJson: false) String? get patientName;@JsonKey(includeToJson: false) String? get providerName;
/// Create a copy of QueueTokenModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueueTokenModelCopyWith<QueueTokenModel> get copyWith => _$QueueTokenModelCopyWithImpl<QueueTokenModel>(this as QueueTokenModel, _$identity);

  /// Serializes this QueueTokenModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueueTokenModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.tokenNumber, tokenNumber) || other.tokenNumber == tokenNumber)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.skipCount, skipCount) || other.skipCount == skipCount)&&(identical(other.calledAt, calledAt) || other.calledAt == calledAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.providerName, providerName) || other.providerName == providerName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clinicId,locationId,tokenNumber,patientId,appointmentId,providerId,status,priority,skipCount,calledAt,startedAt,completedAt,createdAt,patientName,providerName);

@override
String toString() {
  return 'QueueTokenModel(id: $id, clinicId: $clinicId, locationId: $locationId, tokenNumber: $tokenNumber, patientId: $patientId, appointmentId: $appointmentId, providerId: $providerId, status: $status, priority: $priority, skipCount: $skipCount, calledAt: $calledAt, startedAt: $startedAt, completedAt: $completedAt, createdAt: $createdAt, patientName: $patientName, providerName: $providerName)';
}


}

/// @nodoc
abstract mixin class $QueueTokenModelCopyWith<$Res>  {
  factory $QueueTokenModelCopyWith(QueueTokenModel value, $Res Function(QueueTokenModel) _then) = _$QueueTokenModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'clinic_id') String clinicId,@JsonKey(name: 'location_id') String? locationId,@JsonKey(name: 'token_number') int tokenNumber,@JsonKey(name: 'patient_id') String patientId,@JsonKey(name: 'appointment_id') String? appointmentId,@JsonKey(name: 'provider_id') String providerId,@_QueueTokenStatusConverter() QueueTokenStatus status,@_QueuePriorityConverter() QueuePriority priority,@JsonKey(name: 'skip_count') int skipCount,@JsonKey(name: 'called_at') DateTime? calledAt,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(includeToJson: false) String? patientName,@JsonKey(includeToJson: false) String? providerName
});




}
/// @nodoc
class _$QueueTokenModelCopyWithImpl<$Res>
    implements $QueueTokenModelCopyWith<$Res> {
  _$QueueTokenModelCopyWithImpl(this._self, this._then);

  final QueueTokenModel _self;
  final $Res Function(QueueTokenModel) _then;

/// Create a copy of QueueTokenModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clinicId = null,Object? locationId = freezed,Object? tokenNumber = null,Object? patientId = null,Object? appointmentId = freezed,Object? providerId = null,Object? status = null,Object? priority = null,Object? skipCount = null,Object? calledAt = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? createdAt = null,Object? patientName = freezed,Object? providerName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String?,tokenNumber: null == tokenNumber ? _self.tokenNumber : tokenNumber // ignore: cast_nullable_to_non_nullable
as int,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,appointmentId: freezed == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String?,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as QueueTokenStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as QueuePriority,skipCount: null == skipCount ? _self.skipCount : skipCount // ignore: cast_nullable_to_non_nullable
as int,calledAt: freezed == calledAt ? _self.calledAt : calledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,providerName: freezed == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QueueTokenModel].
extension QueueTokenModelPatterns on QueueTokenModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueueTokenModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueueTokenModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueueTokenModel value)  $default,){
final _that = this;
switch (_that) {
case _QueueTokenModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueueTokenModel value)?  $default,){
final _that = this;
switch (_that) {
case _QueueTokenModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'location_id')  String? locationId, @JsonKey(name: 'token_number')  int tokenNumber, @JsonKey(name: 'patient_id')  String patientId, @JsonKey(name: 'appointment_id')  String? appointmentId, @JsonKey(name: 'provider_id')  String providerId, @_QueueTokenStatusConverter()  QueueTokenStatus status, @_QueuePriorityConverter()  QueuePriority priority, @JsonKey(name: 'skip_count')  int skipCount, @JsonKey(name: 'called_at')  DateTime? calledAt, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(includeToJson: false)  String? patientName, @JsonKey(includeToJson: false)  String? providerName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueueTokenModel() when $default != null:
return $default(_that.id,_that.clinicId,_that.locationId,_that.tokenNumber,_that.patientId,_that.appointmentId,_that.providerId,_that.status,_that.priority,_that.skipCount,_that.calledAt,_that.startedAt,_that.completedAt,_that.createdAt,_that.patientName,_that.providerName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'location_id')  String? locationId, @JsonKey(name: 'token_number')  int tokenNumber, @JsonKey(name: 'patient_id')  String patientId, @JsonKey(name: 'appointment_id')  String? appointmentId, @JsonKey(name: 'provider_id')  String providerId, @_QueueTokenStatusConverter()  QueueTokenStatus status, @_QueuePriorityConverter()  QueuePriority priority, @JsonKey(name: 'skip_count')  int skipCount, @JsonKey(name: 'called_at')  DateTime? calledAt, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(includeToJson: false)  String? patientName, @JsonKey(includeToJson: false)  String? providerName)  $default,) {final _that = this;
switch (_that) {
case _QueueTokenModel():
return $default(_that.id,_that.clinicId,_that.locationId,_that.tokenNumber,_that.patientId,_that.appointmentId,_that.providerId,_that.status,_that.priority,_that.skipCount,_that.calledAt,_that.startedAt,_that.completedAt,_that.createdAt,_that.patientName,_that.providerName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'location_id')  String? locationId, @JsonKey(name: 'token_number')  int tokenNumber, @JsonKey(name: 'patient_id')  String patientId, @JsonKey(name: 'appointment_id')  String? appointmentId, @JsonKey(name: 'provider_id')  String providerId, @_QueueTokenStatusConverter()  QueueTokenStatus status, @_QueuePriorityConverter()  QueuePriority priority, @JsonKey(name: 'skip_count')  int skipCount, @JsonKey(name: 'called_at')  DateTime? calledAt, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(includeToJson: false)  String? patientName, @JsonKey(includeToJson: false)  String? providerName)?  $default,) {final _that = this;
switch (_that) {
case _QueueTokenModel() when $default != null:
return $default(_that.id,_that.clinicId,_that.locationId,_that.tokenNumber,_that.patientId,_that.appointmentId,_that.providerId,_that.status,_that.priority,_that.skipCount,_that.calledAt,_that.startedAt,_that.completedAt,_that.createdAt,_that.patientName,_that.providerName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QueueTokenModel implements QueueTokenModel {
  const _QueueTokenModel({required this.id, @JsonKey(name: 'clinic_id') required this.clinicId, @JsonKey(name: 'location_id') this.locationId, @JsonKey(name: 'token_number') required this.tokenNumber, @JsonKey(name: 'patient_id') required this.patientId, @JsonKey(name: 'appointment_id') this.appointmentId, @JsonKey(name: 'provider_id') required this.providerId, @_QueueTokenStatusConverter() this.status = QueueTokenStatus.waiting, @_QueuePriorityConverter() this.priority = QueuePriority.normal, @JsonKey(name: 'skip_count') this.skipCount = 0, @JsonKey(name: 'called_at') this.calledAt, @JsonKey(name: 'started_at') this.startedAt, @JsonKey(name: 'completed_at') this.completedAt, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(includeToJson: false) this.patientName, @JsonKey(includeToJson: false) this.providerName});
  factory _QueueTokenModel.fromJson(Map<String, dynamic> json) => _$QueueTokenModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'clinic_id') final  String clinicId;
@override@JsonKey(name: 'location_id') final  String? locationId;
@override@JsonKey(name: 'token_number') final  int tokenNumber;
@override@JsonKey(name: 'patient_id') final  String patientId;
@override@JsonKey(name: 'appointment_id') final  String? appointmentId;
@override@JsonKey(name: 'provider_id') final  String providerId;
@override@JsonKey()@_QueueTokenStatusConverter() final  QueueTokenStatus status;
@override@JsonKey()@_QueuePriorityConverter() final  QueuePriority priority;
@override@JsonKey(name: 'skip_count') final  int skipCount;
@override@JsonKey(name: 'called_at') final  DateTime? calledAt;
@override@JsonKey(name: 'started_at') final  DateTime? startedAt;
@override@JsonKey(name: 'completed_at') final  DateTime? completedAt;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
// Denormalized — populated from Supabase joins
@override@JsonKey(includeToJson: false) final  String? patientName;
@override@JsonKey(includeToJson: false) final  String? providerName;

/// Create a copy of QueueTokenModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueueTokenModelCopyWith<_QueueTokenModel> get copyWith => __$QueueTokenModelCopyWithImpl<_QueueTokenModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QueueTokenModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueueTokenModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.tokenNumber, tokenNumber) || other.tokenNumber == tokenNumber)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.skipCount, skipCount) || other.skipCount == skipCount)&&(identical(other.calledAt, calledAt) || other.calledAt == calledAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.providerName, providerName) || other.providerName == providerName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clinicId,locationId,tokenNumber,patientId,appointmentId,providerId,status,priority,skipCount,calledAt,startedAt,completedAt,createdAt,patientName,providerName);

@override
String toString() {
  return 'QueueTokenModel(id: $id, clinicId: $clinicId, locationId: $locationId, tokenNumber: $tokenNumber, patientId: $patientId, appointmentId: $appointmentId, providerId: $providerId, status: $status, priority: $priority, skipCount: $skipCount, calledAt: $calledAt, startedAt: $startedAt, completedAt: $completedAt, createdAt: $createdAt, patientName: $patientName, providerName: $providerName)';
}


}

/// @nodoc
abstract mixin class _$QueueTokenModelCopyWith<$Res> implements $QueueTokenModelCopyWith<$Res> {
  factory _$QueueTokenModelCopyWith(_QueueTokenModel value, $Res Function(_QueueTokenModel) _then) = __$QueueTokenModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'clinic_id') String clinicId,@JsonKey(name: 'location_id') String? locationId,@JsonKey(name: 'token_number') int tokenNumber,@JsonKey(name: 'patient_id') String patientId,@JsonKey(name: 'appointment_id') String? appointmentId,@JsonKey(name: 'provider_id') String providerId,@_QueueTokenStatusConverter() QueueTokenStatus status,@_QueuePriorityConverter() QueuePriority priority,@JsonKey(name: 'skip_count') int skipCount,@JsonKey(name: 'called_at') DateTime? calledAt,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(includeToJson: false) String? patientName,@JsonKey(includeToJson: false) String? providerName
});




}
/// @nodoc
class __$QueueTokenModelCopyWithImpl<$Res>
    implements _$QueueTokenModelCopyWith<$Res> {
  __$QueueTokenModelCopyWithImpl(this._self, this._then);

  final _QueueTokenModel _self;
  final $Res Function(_QueueTokenModel) _then;

/// Create a copy of QueueTokenModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clinicId = null,Object? locationId = freezed,Object? tokenNumber = null,Object? patientId = null,Object? appointmentId = freezed,Object? providerId = null,Object? status = null,Object? priority = null,Object? skipCount = null,Object? calledAt = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? createdAt = null,Object? patientName = freezed,Object? providerName = freezed,}) {
  return _then(_QueueTokenModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String?,tokenNumber: null == tokenNumber ? _self.tokenNumber : tokenNumber // ignore: cast_nullable_to_non_nullable
as int,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,appointmentId: freezed == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String?,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as QueueTokenStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as QueuePriority,skipCount: null == skipCount ? _self.skipCount : skipCount // ignore: cast_nullable_to_non_nullable
as int,calledAt: freezed == calledAt ? _self.calledAt : calledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,providerName: freezed == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
