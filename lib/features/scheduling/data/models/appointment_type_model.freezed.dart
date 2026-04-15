// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment_type_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppointmentTypeModel {

 String get id;@JsonKey(name: 'clinic_id') String get clinicId; String get name;@JsonKey(name: 'duration_minutes') int get durationMinutes;@JsonKey(name: 'color_hex') String get colorHex; String? get description;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of AppointmentTypeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentTypeModelCopyWith<AppointmentTypeModel> get copyWith => _$AppointmentTypeModelCopyWithImpl<AppointmentTypeModel>(this as AppointmentTypeModel, _$identity);

  /// Serializes this AppointmentTypeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentTypeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.name, name) || other.name == name)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.description, description) || other.description == description)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clinicId,name,durationMinutes,colorHex,description,isActive,createdAt);

@override
String toString() {
  return 'AppointmentTypeModel(id: $id, clinicId: $clinicId, name: $name, durationMinutes: $durationMinutes, colorHex: $colorHex, description: $description, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AppointmentTypeModelCopyWith<$Res>  {
  factory $AppointmentTypeModelCopyWith(AppointmentTypeModel value, $Res Function(AppointmentTypeModel) _then) = _$AppointmentTypeModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'clinic_id') String clinicId, String name,@JsonKey(name: 'duration_minutes') int durationMinutes,@JsonKey(name: 'color_hex') String colorHex, String? description,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$AppointmentTypeModelCopyWithImpl<$Res>
    implements $AppointmentTypeModelCopyWith<$Res> {
  _$AppointmentTypeModelCopyWithImpl(this._self, this._then);

  final AppointmentTypeModel _self;
  final $Res Function(AppointmentTypeModel) _then;

/// Create a copy of AppointmentTypeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clinicId = null,Object? name = null,Object? durationMinutes = null,Object? colorHex = null,Object? description = freezed,Object? isActive = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AppointmentTypeModel].
extension AppointmentTypeModelPatterns on AppointmentTypeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentTypeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentTypeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentTypeModel value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentTypeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentTypeModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentTypeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'clinic_id')  String clinicId,  String name, @JsonKey(name: 'duration_minutes')  int durationMinutes, @JsonKey(name: 'color_hex')  String colorHex,  String? description, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentTypeModel() when $default != null:
return $default(_that.id,_that.clinicId,_that.name,_that.durationMinutes,_that.colorHex,_that.description,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'clinic_id')  String clinicId,  String name, @JsonKey(name: 'duration_minutes')  int durationMinutes, @JsonKey(name: 'color_hex')  String colorHex,  String? description, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AppointmentTypeModel():
return $default(_that.id,_that.clinicId,_that.name,_that.durationMinutes,_that.colorHex,_that.description,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'clinic_id')  String clinicId,  String name, @JsonKey(name: 'duration_minutes')  int durationMinutes, @JsonKey(name: 'color_hex')  String colorHex,  String? description, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentTypeModel() when $default != null:
return $default(_that.id,_that.clinicId,_that.name,_that.durationMinutes,_that.colorHex,_that.description,_that.isActive,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppointmentTypeModel implements AppointmentTypeModel {
  const _AppointmentTypeModel({required this.id, @JsonKey(name: 'clinic_id') required this.clinicId, required this.name, @JsonKey(name: 'duration_minutes') required this.durationMinutes, @JsonKey(name: 'color_hex') required this.colorHex, this.description, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'created_at') required this.createdAt});
  factory _AppointmentTypeModel.fromJson(Map<String, dynamic> json) => _$AppointmentTypeModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'clinic_id') final  String clinicId;
@override final  String name;
@override@JsonKey(name: 'duration_minutes') final  int durationMinutes;
@override@JsonKey(name: 'color_hex') final  String colorHex;
@override final  String? description;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of AppointmentTypeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentTypeModelCopyWith<_AppointmentTypeModel> get copyWith => __$AppointmentTypeModelCopyWithImpl<_AppointmentTypeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentTypeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentTypeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.name, name) || other.name == name)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.description, description) || other.description == description)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clinicId,name,durationMinutes,colorHex,description,isActive,createdAt);

@override
String toString() {
  return 'AppointmentTypeModel(id: $id, clinicId: $clinicId, name: $name, durationMinutes: $durationMinutes, colorHex: $colorHex, description: $description, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AppointmentTypeModelCopyWith<$Res> implements $AppointmentTypeModelCopyWith<$Res> {
  factory _$AppointmentTypeModelCopyWith(_AppointmentTypeModel value, $Res Function(_AppointmentTypeModel) _then) = __$AppointmentTypeModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'clinic_id') String clinicId, String name,@JsonKey(name: 'duration_minutes') int durationMinutes,@JsonKey(name: 'color_hex') String colorHex, String? description,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$AppointmentTypeModelCopyWithImpl<$Res>
    implements _$AppointmentTypeModelCopyWith<$Res> {
  __$AppointmentTypeModelCopyWithImpl(this._self, this._then);

  final _AppointmentTypeModel _self;
  final $Res Function(_AppointmentTypeModel) _then;

/// Create a copy of AppointmentTypeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clinicId = null,Object? name = null,Object? durationMinutes = null,Object? colorHex = null,Object? description = freezed,Object? isActive = null,Object? createdAt = null,}) {
  return _then(_AppointmentTypeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
