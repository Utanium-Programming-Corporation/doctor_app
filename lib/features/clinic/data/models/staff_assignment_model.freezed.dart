// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_assignment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StaffAssignmentModel {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'clinic_id') String get clinicId;@_StaffRoleConverter() StaffRole get role;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'joined_at') DateTime get joinedAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;@JsonKey(name: 'user_name') String? get userName;
/// Create a copy of StaffAssignmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaffAssignmentModelCopyWith<StaffAssignmentModel> get copyWith => _$StaffAssignmentModelCopyWithImpl<StaffAssignmentModel>(this as StaffAssignmentModel, _$identity);

  /// Serializes this StaffAssignmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaffAssignmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.userName, userName) || other.userName == userName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,clinicId,role,isActive,joinedAt,updatedAt,userName);

@override
String toString() {
  return 'StaffAssignmentModel(id: $id, userId: $userId, clinicId: $clinicId, role: $role, isActive: $isActive, joinedAt: $joinedAt, updatedAt: $updatedAt, userName: $userName)';
}


}

/// @nodoc
abstract mixin class $StaffAssignmentModelCopyWith<$Res>  {
  factory $StaffAssignmentModelCopyWith(StaffAssignmentModel value, $Res Function(StaffAssignmentModel) _then) = _$StaffAssignmentModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'clinic_id') String clinicId,@_StaffRoleConverter() StaffRole role,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'joined_at') DateTime joinedAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(name: 'user_name') String? userName
});




}
/// @nodoc
class _$StaffAssignmentModelCopyWithImpl<$Res>
    implements $StaffAssignmentModelCopyWith<$Res> {
  _$StaffAssignmentModelCopyWithImpl(this._self, this._then);

  final StaffAssignmentModel _self;
  final $Res Function(StaffAssignmentModel) _then;

/// Create a copy of StaffAssignmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? clinicId = null,Object? role = null,Object? isActive = null,Object? joinedAt = null,Object? updatedAt = null,Object? userName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as StaffRole,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StaffAssignmentModel].
extension StaffAssignmentModelPatterns on StaffAssignmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaffAssignmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaffAssignmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaffAssignmentModel value)  $default,){
final _that = this;
switch (_that) {
case _StaffAssignmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaffAssignmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _StaffAssignmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'clinic_id')  String clinicId, @_StaffRoleConverter()  StaffRole role, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'joined_at')  DateTime joinedAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'user_name')  String? userName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaffAssignmentModel() when $default != null:
return $default(_that.id,_that.userId,_that.clinicId,_that.role,_that.isActive,_that.joinedAt,_that.updatedAt,_that.userName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'clinic_id')  String clinicId, @_StaffRoleConverter()  StaffRole role, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'joined_at')  DateTime joinedAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'user_name')  String? userName)  $default,) {final _that = this;
switch (_that) {
case _StaffAssignmentModel():
return $default(_that.id,_that.userId,_that.clinicId,_that.role,_that.isActive,_that.joinedAt,_that.updatedAt,_that.userName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'clinic_id')  String clinicId, @_StaffRoleConverter()  StaffRole role, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'joined_at')  DateTime joinedAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'user_name')  String? userName)?  $default,) {final _that = this;
switch (_that) {
case _StaffAssignmentModel() when $default != null:
return $default(_that.id,_that.userId,_that.clinicId,_that.role,_that.isActive,_that.joinedAt,_that.updatedAt,_that.userName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StaffAssignmentModel implements StaffAssignmentModel {
  const _StaffAssignmentModel({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'clinic_id') required this.clinicId, @_StaffRoleConverter() required this.role, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'joined_at') required this.joinedAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'user_name') this.userName});
  factory _StaffAssignmentModel.fromJson(Map<String, dynamic> json) => _$StaffAssignmentModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'clinic_id') final  String clinicId;
@override@_StaffRoleConverter() final  StaffRole role;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'joined_at') final  DateTime joinedAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;
@override@JsonKey(name: 'user_name') final  String? userName;

/// Create a copy of StaffAssignmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaffAssignmentModelCopyWith<_StaffAssignmentModel> get copyWith => __$StaffAssignmentModelCopyWithImpl<_StaffAssignmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StaffAssignmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaffAssignmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.userName, userName) || other.userName == userName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,clinicId,role,isActive,joinedAt,updatedAt,userName);

@override
String toString() {
  return 'StaffAssignmentModel(id: $id, userId: $userId, clinicId: $clinicId, role: $role, isActive: $isActive, joinedAt: $joinedAt, updatedAt: $updatedAt, userName: $userName)';
}


}

/// @nodoc
abstract mixin class _$StaffAssignmentModelCopyWith<$Res> implements $StaffAssignmentModelCopyWith<$Res> {
  factory _$StaffAssignmentModelCopyWith(_StaffAssignmentModel value, $Res Function(_StaffAssignmentModel) _then) = __$StaffAssignmentModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'clinic_id') String clinicId,@_StaffRoleConverter() StaffRole role,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'joined_at') DateTime joinedAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(name: 'user_name') String? userName
});




}
/// @nodoc
class __$StaffAssignmentModelCopyWithImpl<$Res>
    implements _$StaffAssignmentModelCopyWith<$Res> {
  __$StaffAssignmentModelCopyWithImpl(this._self, this._then);

  final _StaffAssignmentModel _self;
  final $Res Function(_StaffAssignmentModel) _then;

/// Create a copy of StaffAssignmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? clinicId = null,Object? role = null,Object? isActive = null,Object? joinedAt = null,Object? updatedAt = null,Object? userName = freezed,}) {
  return _then(_StaffAssignmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as StaffRole,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
