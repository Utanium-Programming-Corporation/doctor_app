// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocked_date_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockedDateModel {

 String get id;@JsonKey(name: 'clinic_id') String get clinicId;@JsonKey(name: 'provider_id') String get providerId;@JsonKey(name: 'blocked_date') DateTime get blockedDate; String? get reason;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of BlockedDateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockedDateModelCopyWith<BlockedDateModel> get copyWith => _$BlockedDateModelCopyWithImpl<BlockedDateModel>(this as BlockedDateModel, _$identity);

  /// Serializes this BlockedDateModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockedDateModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.blockedDate, blockedDate) || other.blockedDate == blockedDate)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clinicId,providerId,blockedDate,reason,createdAt);

@override
String toString() {
  return 'BlockedDateModel(id: $id, clinicId: $clinicId, providerId: $providerId, blockedDate: $blockedDate, reason: $reason, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BlockedDateModelCopyWith<$Res>  {
  factory $BlockedDateModelCopyWith(BlockedDateModel value, $Res Function(BlockedDateModel) _then) = _$BlockedDateModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'clinic_id') String clinicId,@JsonKey(name: 'provider_id') String providerId,@JsonKey(name: 'blocked_date') DateTime blockedDate, String? reason,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$BlockedDateModelCopyWithImpl<$Res>
    implements $BlockedDateModelCopyWith<$Res> {
  _$BlockedDateModelCopyWithImpl(this._self, this._then);

  final BlockedDateModel _self;
  final $Res Function(BlockedDateModel) _then;

/// Create a copy of BlockedDateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clinicId = null,Object? providerId = null,Object? blockedDate = null,Object? reason = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,blockedDate: null == blockedDate ? _self.blockedDate : blockedDate // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BlockedDateModel].
extension BlockedDateModelPatterns on BlockedDateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlockedDateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlockedDateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlockedDateModel value)  $default,){
final _that = this;
switch (_that) {
case _BlockedDateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlockedDateModel value)?  $default,){
final _that = this;
switch (_that) {
case _BlockedDateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'provider_id')  String providerId, @JsonKey(name: 'blocked_date')  DateTime blockedDate,  String? reason, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlockedDateModel() when $default != null:
return $default(_that.id,_that.clinicId,_that.providerId,_that.blockedDate,_that.reason,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'provider_id')  String providerId, @JsonKey(name: 'blocked_date')  DateTime blockedDate,  String? reason, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _BlockedDateModel():
return $default(_that.id,_that.clinicId,_that.providerId,_that.blockedDate,_that.reason,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'provider_id')  String providerId, @JsonKey(name: 'blocked_date')  DateTime blockedDate,  String? reason, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BlockedDateModel() when $default != null:
return $default(_that.id,_that.clinicId,_that.providerId,_that.blockedDate,_that.reason,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BlockedDateModel implements BlockedDateModel {
  const _BlockedDateModel({required this.id, @JsonKey(name: 'clinic_id') required this.clinicId, @JsonKey(name: 'provider_id') required this.providerId, @JsonKey(name: 'blocked_date') required this.blockedDate, this.reason, @JsonKey(name: 'created_at') required this.createdAt});
  factory _BlockedDateModel.fromJson(Map<String, dynamic> json) => _$BlockedDateModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'clinic_id') final  String clinicId;
@override@JsonKey(name: 'provider_id') final  String providerId;
@override@JsonKey(name: 'blocked_date') final  DateTime blockedDate;
@override final  String? reason;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of BlockedDateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockedDateModelCopyWith<_BlockedDateModel> get copyWith => __$BlockedDateModelCopyWithImpl<_BlockedDateModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockedDateModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockedDateModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.blockedDate, blockedDate) || other.blockedDate == blockedDate)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clinicId,providerId,blockedDate,reason,createdAt);

@override
String toString() {
  return 'BlockedDateModel(id: $id, clinicId: $clinicId, providerId: $providerId, blockedDate: $blockedDate, reason: $reason, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BlockedDateModelCopyWith<$Res> implements $BlockedDateModelCopyWith<$Res> {
  factory _$BlockedDateModelCopyWith(_BlockedDateModel value, $Res Function(_BlockedDateModel) _then) = __$BlockedDateModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'clinic_id') String clinicId,@JsonKey(name: 'provider_id') String providerId,@JsonKey(name: 'blocked_date') DateTime blockedDate, String? reason,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$BlockedDateModelCopyWithImpl<$Res>
    implements _$BlockedDateModelCopyWith<$Res> {
  __$BlockedDateModelCopyWithImpl(this._self, this._then);

  final _BlockedDateModel _self;
  final $Res Function(_BlockedDateModel) _then;

/// Create a copy of BlockedDateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clinicId = null,Object? providerId = null,Object? blockedDate = null,Object? reason = freezed,Object? createdAt = null,}) {
  return _then(_BlockedDateModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,blockedDate: null == blockedDate ? _self.blockedDate : blockedDate // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
