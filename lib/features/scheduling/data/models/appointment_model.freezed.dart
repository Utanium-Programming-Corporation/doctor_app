// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppointmentModel {

 String get id;@JsonKey(name: 'clinic_id') String get clinicId;@JsonKey(name: 'patient_id') String get patientId;@JsonKey(name: 'provider_id') String get providerId;@JsonKey(name: 'appointment_type_id') String get appointmentTypeId;@JsonKey(name: 'location_id') String? get locationId;@JsonKey(name: 'start_time') DateTime get startTime;@JsonKey(name: 'end_time') DateTime get endTime;@_AppointmentStatusConverter() AppointmentStatus get status;@JsonKey(name: 'cancel_reason') String? get cancelReason; String? get notes;@JsonKey(name: 'created_by') String get createdBy;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;// Denormalized — populated from Supabase joins
@JsonKey(includeToJson: false) String? get patientName;@JsonKey(includeToJson: false) String? get appointmentTypeName;@JsonKey(includeToJson: false) String? get appointmentTypeColor;@JsonKey(includeToJson: false) String? get providerName;
/// Create a copy of AppointmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentModelCopyWith<AppointmentModel> get copyWith => _$AppointmentModelCopyWithImpl<AppointmentModel>(this as AppointmentModel, _$identity);

  /// Serializes this AppointmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.appointmentTypeId, appointmentTypeId) || other.appointmentTypeId == appointmentTypeId)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.appointmentTypeName, appointmentTypeName) || other.appointmentTypeName == appointmentTypeName)&&(identical(other.appointmentTypeColor, appointmentTypeColor) || other.appointmentTypeColor == appointmentTypeColor)&&(identical(other.providerName, providerName) || other.providerName == providerName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clinicId,patientId,providerId,appointmentTypeId,locationId,startTime,endTime,status,cancelReason,notes,createdBy,createdAt,updatedAt,patientName,appointmentTypeName,appointmentTypeColor,providerName);

@override
String toString() {
  return 'AppointmentModel(id: $id, clinicId: $clinicId, patientId: $patientId, providerId: $providerId, appointmentTypeId: $appointmentTypeId, locationId: $locationId, startTime: $startTime, endTime: $endTime, status: $status, cancelReason: $cancelReason, notes: $notes, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, patientName: $patientName, appointmentTypeName: $appointmentTypeName, appointmentTypeColor: $appointmentTypeColor, providerName: $providerName)';
}


}

/// @nodoc
abstract mixin class $AppointmentModelCopyWith<$Res>  {
  factory $AppointmentModelCopyWith(AppointmentModel value, $Res Function(AppointmentModel) _then) = _$AppointmentModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'clinic_id') String clinicId,@JsonKey(name: 'patient_id') String patientId,@JsonKey(name: 'provider_id') String providerId,@JsonKey(name: 'appointment_type_id') String appointmentTypeId,@JsonKey(name: 'location_id') String? locationId,@JsonKey(name: 'start_time') DateTime startTime,@JsonKey(name: 'end_time') DateTime endTime,@_AppointmentStatusConverter() AppointmentStatus status,@JsonKey(name: 'cancel_reason') String? cancelReason, String? notes,@JsonKey(name: 'created_by') String createdBy,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(includeToJson: false) String? patientName,@JsonKey(includeToJson: false) String? appointmentTypeName,@JsonKey(includeToJson: false) String? appointmentTypeColor,@JsonKey(includeToJson: false) String? providerName
});




}
/// @nodoc
class _$AppointmentModelCopyWithImpl<$Res>
    implements $AppointmentModelCopyWith<$Res> {
  _$AppointmentModelCopyWithImpl(this._self, this._then);

  final AppointmentModel _self;
  final $Res Function(AppointmentModel) _then;

/// Create a copy of AppointmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clinicId = null,Object? patientId = null,Object? providerId = null,Object? appointmentTypeId = null,Object? locationId = freezed,Object? startTime = null,Object? endTime = null,Object? status = null,Object? cancelReason = freezed,Object? notes = freezed,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,Object? patientName = freezed,Object? appointmentTypeName = freezed,Object? appointmentTypeColor = freezed,Object? providerName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,appointmentTypeId: null == appointmentTypeId ? _self.appointmentTypeId : appointmentTypeId // ignore: cast_nullable_to_non_nullable
as String,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String?,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AppointmentStatus,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,appointmentTypeName: freezed == appointmentTypeName ? _self.appointmentTypeName : appointmentTypeName // ignore: cast_nullable_to_non_nullable
as String?,appointmentTypeColor: freezed == appointmentTypeColor ? _self.appointmentTypeColor : appointmentTypeColor // ignore: cast_nullable_to_non_nullable
as String?,providerName: freezed == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppointmentModel].
extension AppointmentModelPatterns on AppointmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentModel value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'patient_id')  String patientId, @JsonKey(name: 'provider_id')  String providerId, @JsonKey(name: 'appointment_type_id')  String appointmentTypeId, @JsonKey(name: 'location_id')  String? locationId, @JsonKey(name: 'start_time')  DateTime startTime, @JsonKey(name: 'end_time')  DateTime endTime, @_AppointmentStatusConverter()  AppointmentStatus status, @JsonKey(name: 'cancel_reason')  String? cancelReason,  String? notes, @JsonKey(name: 'created_by')  String createdBy, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(includeToJson: false)  String? patientName, @JsonKey(includeToJson: false)  String? appointmentTypeName, @JsonKey(includeToJson: false)  String? appointmentTypeColor, @JsonKey(includeToJson: false)  String? providerName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentModel() when $default != null:
return $default(_that.id,_that.clinicId,_that.patientId,_that.providerId,_that.appointmentTypeId,_that.locationId,_that.startTime,_that.endTime,_that.status,_that.cancelReason,_that.notes,_that.createdBy,_that.createdAt,_that.updatedAt,_that.patientName,_that.appointmentTypeName,_that.appointmentTypeColor,_that.providerName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'patient_id')  String patientId, @JsonKey(name: 'provider_id')  String providerId, @JsonKey(name: 'appointment_type_id')  String appointmentTypeId, @JsonKey(name: 'location_id')  String? locationId, @JsonKey(name: 'start_time')  DateTime startTime, @JsonKey(name: 'end_time')  DateTime endTime, @_AppointmentStatusConverter()  AppointmentStatus status, @JsonKey(name: 'cancel_reason')  String? cancelReason,  String? notes, @JsonKey(name: 'created_by')  String createdBy, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(includeToJson: false)  String? patientName, @JsonKey(includeToJson: false)  String? appointmentTypeName, @JsonKey(includeToJson: false)  String? appointmentTypeColor, @JsonKey(includeToJson: false)  String? providerName)  $default,) {final _that = this;
switch (_that) {
case _AppointmentModel():
return $default(_that.id,_that.clinicId,_that.patientId,_that.providerId,_that.appointmentTypeId,_that.locationId,_that.startTime,_that.endTime,_that.status,_that.cancelReason,_that.notes,_that.createdBy,_that.createdAt,_that.updatedAt,_that.patientName,_that.appointmentTypeName,_that.appointmentTypeColor,_that.providerName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'patient_id')  String patientId, @JsonKey(name: 'provider_id')  String providerId, @JsonKey(name: 'appointment_type_id')  String appointmentTypeId, @JsonKey(name: 'location_id')  String? locationId, @JsonKey(name: 'start_time')  DateTime startTime, @JsonKey(name: 'end_time')  DateTime endTime, @_AppointmentStatusConverter()  AppointmentStatus status, @JsonKey(name: 'cancel_reason')  String? cancelReason,  String? notes, @JsonKey(name: 'created_by')  String createdBy, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(includeToJson: false)  String? patientName, @JsonKey(includeToJson: false)  String? appointmentTypeName, @JsonKey(includeToJson: false)  String? appointmentTypeColor, @JsonKey(includeToJson: false)  String? providerName)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentModel() when $default != null:
return $default(_that.id,_that.clinicId,_that.patientId,_that.providerId,_that.appointmentTypeId,_that.locationId,_that.startTime,_that.endTime,_that.status,_that.cancelReason,_that.notes,_that.createdBy,_that.createdAt,_that.updatedAt,_that.patientName,_that.appointmentTypeName,_that.appointmentTypeColor,_that.providerName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppointmentModel implements AppointmentModel {
  const _AppointmentModel({required this.id, @JsonKey(name: 'clinic_id') required this.clinicId, @JsonKey(name: 'patient_id') required this.patientId, @JsonKey(name: 'provider_id') required this.providerId, @JsonKey(name: 'appointment_type_id') required this.appointmentTypeId, @JsonKey(name: 'location_id') this.locationId, @JsonKey(name: 'start_time') required this.startTime, @JsonKey(name: 'end_time') required this.endTime, @_AppointmentStatusConverter() this.status = AppointmentStatus.scheduled, @JsonKey(name: 'cancel_reason') this.cancelReason, this.notes, @JsonKey(name: 'created_by') required this.createdBy, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(includeToJson: false) this.patientName, @JsonKey(includeToJson: false) this.appointmentTypeName, @JsonKey(includeToJson: false) this.appointmentTypeColor, @JsonKey(includeToJson: false) this.providerName});
  factory _AppointmentModel.fromJson(Map<String, dynamic> json) => _$AppointmentModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'clinic_id') final  String clinicId;
@override@JsonKey(name: 'patient_id') final  String patientId;
@override@JsonKey(name: 'provider_id') final  String providerId;
@override@JsonKey(name: 'appointment_type_id') final  String appointmentTypeId;
@override@JsonKey(name: 'location_id') final  String? locationId;
@override@JsonKey(name: 'start_time') final  DateTime startTime;
@override@JsonKey(name: 'end_time') final  DateTime endTime;
@override@JsonKey()@_AppointmentStatusConverter() final  AppointmentStatus status;
@override@JsonKey(name: 'cancel_reason') final  String? cancelReason;
@override final  String? notes;
@override@JsonKey(name: 'created_by') final  String createdBy;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;
// Denormalized — populated from Supabase joins
@override@JsonKey(includeToJson: false) final  String? patientName;
@override@JsonKey(includeToJson: false) final  String? appointmentTypeName;
@override@JsonKey(includeToJson: false) final  String? appointmentTypeColor;
@override@JsonKey(includeToJson: false) final  String? providerName;

/// Create a copy of AppointmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentModelCopyWith<_AppointmentModel> get copyWith => __$AppointmentModelCopyWithImpl<_AppointmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.appointmentTypeId, appointmentTypeId) || other.appointmentTypeId == appointmentTypeId)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.appointmentTypeName, appointmentTypeName) || other.appointmentTypeName == appointmentTypeName)&&(identical(other.appointmentTypeColor, appointmentTypeColor) || other.appointmentTypeColor == appointmentTypeColor)&&(identical(other.providerName, providerName) || other.providerName == providerName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clinicId,patientId,providerId,appointmentTypeId,locationId,startTime,endTime,status,cancelReason,notes,createdBy,createdAt,updatedAt,patientName,appointmentTypeName,appointmentTypeColor,providerName);

@override
String toString() {
  return 'AppointmentModel(id: $id, clinicId: $clinicId, patientId: $patientId, providerId: $providerId, appointmentTypeId: $appointmentTypeId, locationId: $locationId, startTime: $startTime, endTime: $endTime, status: $status, cancelReason: $cancelReason, notes: $notes, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, patientName: $patientName, appointmentTypeName: $appointmentTypeName, appointmentTypeColor: $appointmentTypeColor, providerName: $providerName)';
}


}

/// @nodoc
abstract mixin class _$AppointmentModelCopyWith<$Res> implements $AppointmentModelCopyWith<$Res> {
  factory _$AppointmentModelCopyWith(_AppointmentModel value, $Res Function(_AppointmentModel) _then) = __$AppointmentModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'clinic_id') String clinicId,@JsonKey(name: 'patient_id') String patientId,@JsonKey(name: 'provider_id') String providerId,@JsonKey(name: 'appointment_type_id') String appointmentTypeId,@JsonKey(name: 'location_id') String? locationId,@JsonKey(name: 'start_time') DateTime startTime,@JsonKey(name: 'end_time') DateTime endTime,@_AppointmentStatusConverter() AppointmentStatus status,@JsonKey(name: 'cancel_reason') String? cancelReason, String? notes,@JsonKey(name: 'created_by') String createdBy,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(includeToJson: false) String? patientName,@JsonKey(includeToJson: false) String? appointmentTypeName,@JsonKey(includeToJson: false) String? appointmentTypeColor,@JsonKey(includeToJson: false) String? providerName
});




}
/// @nodoc
class __$AppointmentModelCopyWithImpl<$Res>
    implements _$AppointmentModelCopyWith<$Res> {
  __$AppointmentModelCopyWithImpl(this._self, this._then);

  final _AppointmentModel _self;
  final $Res Function(_AppointmentModel) _then;

/// Create a copy of AppointmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clinicId = null,Object? patientId = null,Object? providerId = null,Object? appointmentTypeId = null,Object? locationId = freezed,Object? startTime = null,Object? endTime = null,Object? status = null,Object? cancelReason = freezed,Object? notes = freezed,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,Object? patientName = freezed,Object? appointmentTypeName = freezed,Object? appointmentTypeColor = freezed,Object? providerName = freezed,}) {
  return _then(_AppointmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,appointmentTypeId: null == appointmentTypeId ? _self.appointmentTypeId : appointmentTypeId // ignore: cast_nullable_to_non_nullable
as String,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String?,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AppointmentStatus,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,appointmentTypeName: freezed == appointmentTypeName ? _self.appointmentTypeName : appointmentTypeName // ignore: cast_nullable_to_non_nullable
as String?,appointmentTypeColor: freezed == appointmentTypeColor ? _self.appointmentTypeColor : appointmentTypeColor // ignore: cast_nullable_to_non_nullable
as String?,providerName: freezed == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
