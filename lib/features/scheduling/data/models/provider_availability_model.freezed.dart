// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provider_availability_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProviderAvailabilityModel {

 String get id;@JsonKey(name: 'clinic_id') String get clinicId;@JsonKey(name: 'provider_id') String get providerId;@JsonKey(name: 'day_of_week') int get dayOfWeek;@JsonKey(name: 'start_time') String get startTime;@JsonKey(name: 'end_time') String get endTime;@JsonKey(name: 'location_id') String? get locationId;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of ProviderAvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProviderAvailabilityModelCopyWith<ProviderAvailabilityModel> get copyWith => _$ProviderAvailabilityModelCopyWithImpl<ProviderAvailabilityModel>(this as ProviderAvailabilityModel, _$identity);

  /// Serializes this ProviderAvailabilityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProviderAvailabilityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clinicId,providerId,dayOfWeek,startTime,endTime,locationId,isActive);

@override
String toString() {
  return 'ProviderAvailabilityModel(id: $id, clinicId: $clinicId, providerId: $providerId, dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, locationId: $locationId, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ProviderAvailabilityModelCopyWith<$Res>  {
  factory $ProviderAvailabilityModelCopyWith(ProviderAvailabilityModel value, $Res Function(ProviderAvailabilityModel) _then) = _$ProviderAvailabilityModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'clinic_id') String clinicId,@JsonKey(name: 'provider_id') String providerId,@JsonKey(name: 'day_of_week') int dayOfWeek,@JsonKey(name: 'start_time') String startTime,@JsonKey(name: 'end_time') String endTime,@JsonKey(name: 'location_id') String? locationId,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$ProviderAvailabilityModelCopyWithImpl<$Res>
    implements $ProviderAvailabilityModelCopyWith<$Res> {
  _$ProviderAvailabilityModelCopyWithImpl(this._self, this._then);

  final ProviderAvailabilityModel _self;
  final $Res Function(ProviderAvailabilityModel) _then;

/// Create a copy of ProviderAvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clinicId = null,Object? providerId = null,Object? dayOfWeek = null,Object? startTime = null,Object? endTime = null,Object? locationId = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProviderAvailabilityModel].
extension ProviderAvailabilityModelPatterns on ProviderAvailabilityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProviderAvailabilityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProviderAvailabilityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProviderAvailabilityModel value)  $default,){
final _that = this;
switch (_that) {
case _ProviderAvailabilityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProviderAvailabilityModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProviderAvailabilityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'provider_id')  String providerId, @JsonKey(name: 'day_of_week')  int dayOfWeek, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime, @JsonKey(name: 'location_id')  String? locationId, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProviderAvailabilityModel() when $default != null:
return $default(_that.id,_that.clinicId,_that.providerId,_that.dayOfWeek,_that.startTime,_that.endTime,_that.locationId,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'provider_id')  String providerId, @JsonKey(name: 'day_of_week')  int dayOfWeek, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime, @JsonKey(name: 'location_id')  String? locationId, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _ProviderAvailabilityModel():
return $default(_that.id,_that.clinicId,_that.providerId,_that.dayOfWeek,_that.startTime,_that.endTime,_that.locationId,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'provider_id')  String providerId, @JsonKey(name: 'day_of_week')  int dayOfWeek, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime, @JsonKey(name: 'location_id')  String? locationId, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _ProviderAvailabilityModel() when $default != null:
return $default(_that.id,_that.clinicId,_that.providerId,_that.dayOfWeek,_that.startTime,_that.endTime,_that.locationId,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProviderAvailabilityModel implements ProviderAvailabilityModel {
  const _ProviderAvailabilityModel({required this.id, @JsonKey(name: 'clinic_id') required this.clinicId, @JsonKey(name: 'provider_id') required this.providerId, @JsonKey(name: 'day_of_week') required this.dayOfWeek, @JsonKey(name: 'start_time') required this.startTime, @JsonKey(name: 'end_time') required this.endTime, @JsonKey(name: 'location_id') this.locationId, @JsonKey(name: 'is_active') this.isActive = true});
  factory _ProviderAvailabilityModel.fromJson(Map<String, dynamic> json) => _$ProviderAvailabilityModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'clinic_id') final  String clinicId;
@override@JsonKey(name: 'provider_id') final  String providerId;
@override@JsonKey(name: 'day_of_week') final  int dayOfWeek;
@override@JsonKey(name: 'start_time') final  String startTime;
@override@JsonKey(name: 'end_time') final  String endTime;
@override@JsonKey(name: 'location_id') final  String? locationId;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of ProviderAvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProviderAvailabilityModelCopyWith<_ProviderAvailabilityModel> get copyWith => __$ProviderAvailabilityModelCopyWithImpl<_ProviderAvailabilityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProviderAvailabilityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProviderAvailabilityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clinicId,providerId,dayOfWeek,startTime,endTime,locationId,isActive);

@override
String toString() {
  return 'ProviderAvailabilityModel(id: $id, clinicId: $clinicId, providerId: $providerId, dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, locationId: $locationId, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ProviderAvailabilityModelCopyWith<$Res> implements $ProviderAvailabilityModelCopyWith<$Res> {
  factory _$ProviderAvailabilityModelCopyWith(_ProviderAvailabilityModel value, $Res Function(_ProviderAvailabilityModel) _then) = __$ProviderAvailabilityModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'clinic_id') String clinicId,@JsonKey(name: 'provider_id') String providerId,@JsonKey(name: 'day_of_week') int dayOfWeek,@JsonKey(name: 'start_time') String startTime,@JsonKey(name: 'end_time') String endTime,@JsonKey(name: 'location_id') String? locationId,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$ProviderAvailabilityModelCopyWithImpl<$Res>
    implements _$ProviderAvailabilityModelCopyWith<$Res> {
  __$ProviderAvailabilityModelCopyWithImpl(this._self, this._then);

  final _ProviderAvailabilityModel _self;
  final $Res Function(_ProviderAvailabilityModel) _then;

/// Create a copy of ProviderAvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clinicId = null,Object? providerId = null,Object? dayOfWeek = null,Object? startTime = null,Object? endTime = null,Object? locationId = freezed,Object? isActive = null,}) {
  return _then(_ProviderAvailabilityModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
