// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PatientModel {

 String get id;@JsonKey(name: 'clinic_id') String get clinicId;@JsonKey(name: 'patient_number') String get patientNumber;@JsonKey(name: 'first_name') String get firstName;@JsonKey(name: 'last_name') String get lastName;@JsonKey(name: 'date_of_birth') DateTime get dateOfBirth;@_GenderConverter() Gender? get gender;@JsonKey(name: 'phone_number') String get phoneNumber; String? get email;@JsonKey(name: 'national_id') String? get nationalId;@JsonKey(name: 'blood_type')@_BloodTypeConverter() BloodType? get bloodType; String? get address;@JsonKey(name: 'emergency_contact_name') String? get emergencyContactName;@JsonKey(name: 'emergency_contact_phone') String? get emergencyContactPhone; String? get notes;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of PatientModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientModelCopyWith<PatientModel> get copyWith => _$PatientModelCopyWithImpl<PatientModel>(this as PatientModel, _$identity);

  /// Serializes this PatientModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.patientNumber, patientNumber) || other.patientNumber == patientNumber)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.email, email) || other.email == email)&&(identical(other.nationalId, nationalId) || other.nationalId == nationalId)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.address, address) || other.address == address)&&(identical(other.emergencyContactName, emergencyContactName) || other.emergencyContactName == emergencyContactName)&&(identical(other.emergencyContactPhone, emergencyContactPhone) || other.emergencyContactPhone == emergencyContactPhone)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clinicId,patientNumber,firstName,lastName,dateOfBirth,gender,phoneNumber,email,nationalId,bloodType,address,emergencyContactName,emergencyContactPhone,notes,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'PatientModel(id: $id, clinicId: $clinicId, patientNumber: $patientNumber, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, gender: $gender, phoneNumber: $phoneNumber, email: $email, nationalId: $nationalId, bloodType: $bloodType, address: $address, emergencyContactName: $emergencyContactName, emergencyContactPhone: $emergencyContactPhone, notes: $notes, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PatientModelCopyWith<$Res>  {
  factory $PatientModelCopyWith(PatientModel value, $Res Function(PatientModel) _then) = _$PatientModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'clinic_id') String clinicId,@JsonKey(name: 'patient_number') String patientNumber,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName,@JsonKey(name: 'date_of_birth') DateTime dateOfBirth,@_GenderConverter() Gender? gender,@JsonKey(name: 'phone_number') String phoneNumber, String? email,@JsonKey(name: 'national_id') String? nationalId,@JsonKey(name: 'blood_type')@_BloodTypeConverter() BloodType? bloodType, String? address,@JsonKey(name: 'emergency_contact_name') String? emergencyContactName,@JsonKey(name: 'emergency_contact_phone') String? emergencyContactPhone, String? notes,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$PatientModelCopyWithImpl<$Res>
    implements $PatientModelCopyWith<$Res> {
  _$PatientModelCopyWithImpl(this._self, this._then);

  final PatientModel _self;
  final $Res Function(PatientModel) _then;

/// Create a copy of PatientModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clinicId = null,Object? patientNumber = null,Object? firstName = null,Object? lastName = null,Object? dateOfBirth = null,Object? gender = freezed,Object? phoneNumber = null,Object? email = freezed,Object? nationalId = freezed,Object? bloodType = freezed,Object? address = freezed,Object? emergencyContactName = freezed,Object? emergencyContactPhone = freezed,Object? notes = freezed,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,patientNumber: null == patientNumber ? _self.patientNumber : patientNumber // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,nationalId: freezed == nationalId ? _self.nationalId : nationalId // ignore: cast_nullable_to_non_nullable
as String?,bloodType: freezed == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as BloodType?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,emergencyContactName: freezed == emergencyContactName ? _self.emergencyContactName : emergencyContactName // ignore: cast_nullable_to_non_nullable
as String?,emergencyContactPhone: freezed == emergencyContactPhone ? _self.emergencyContactPhone : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PatientModel].
extension PatientModelPatterns on PatientModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PatientModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PatientModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PatientModel value)  $default,){
final _that = this;
switch (_that) {
case _PatientModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PatientModel value)?  $default,){
final _that = this;
switch (_that) {
case _PatientModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'patient_number')  String patientNumber, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'date_of_birth')  DateTime dateOfBirth, @_GenderConverter()  Gender? gender, @JsonKey(name: 'phone_number')  String phoneNumber,  String? email, @JsonKey(name: 'national_id')  String? nationalId, @JsonKey(name: 'blood_type')@_BloodTypeConverter()  BloodType? bloodType,  String? address, @JsonKey(name: 'emergency_contact_name')  String? emergencyContactName, @JsonKey(name: 'emergency_contact_phone')  String? emergencyContactPhone,  String? notes, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientModel() when $default != null:
return $default(_that.id,_that.clinicId,_that.patientNumber,_that.firstName,_that.lastName,_that.dateOfBirth,_that.gender,_that.phoneNumber,_that.email,_that.nationalId,_that.bloodType,_that.address,_that.emergencyContactName,_that.emergencyContactPhone,_that.notes,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'patient_number')  String patientNumber, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'date_of_birth')  DateTime dateOfBirth, @_GenderConverter()  Gender? gender, @JsonKey(name: 'phone_number')  String phoneNumber,  String? email, @JsonKey(name: 'national_id')  String? nationalId, @JsonKey(name: 'blood_type')@_BloodTypeConverter()  BloodType? bloodType,  String? address, @JsonKey(name: 'emergency_contact_name')  String? emergencyContactName, @JsonKey(name: 'emergency_contact_phone')  String? emergencyContactPhone,  String? notes, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PatientModel():
return $default(_that.id,_that.clinicId,_that.patientNumber,_that.firstName,_that.lastName,_that.dateOfBirth,_that.gender,_that.phoneNumber,_that.email,_that.nationalId,_that.bloodType,_that.address,_that.emergencyContactName,_that.emergencyContactPhone,_that.notes,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'patient_number')  String patientNumber, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'date_of_birth')  DateTime dateOfBirth, @_GenderConverter()  Gender? gender, @JsonKey(name: 'phone_number')  String phoneNumber,  String? email, @JsonKey(name: 'national_id')  String? nationalId, @JsonKey(name: 'blood_type')@_BloodTypeConverter()  BloodType? bloodType,  String? address, @JsonKey(name: 'emergency_contact_name')  String? emergencyContactName, @JsonKey(name: 'emergency_contact_phone')  String? emergencyContactPhone,  String? notes, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PatientModel() when $default != null:
return $default(_that.id,_that.clinicId,_that.patientNumber,_that.firstName,_that.lastName,_that.dateOfBirth,_that.gender,_that.phoneNumber,_that.email,_that.nationalId,_that.bloodType,_that.address,_that.emergencyContactName,_that.emergencyContactPhone,_that.notes,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PatientModel implements PatientModel {
  const _PatientModel({required this.id, @JsonKey(name: 'clinic_id') required this.clinicId, @JsonKey(name: 'patient_number') required this.patientNumber, @JsonKey(name: 'first_name') required this.firstName, @JsonKey(name: 'last_name') required this.lastName, @JsonKey(name: 'date_of_birth') required this.dateOfBirth, @_GenderConverter() this.gender, @JsonKey(name: 'phone_number') required this.phoneNumber, this.email, @JsonKey(name: 'national_id') this.nationalId, @JsonKey(name: 'blood_type')@_BloodTypeConverter() this.bloodType, this.address, @JsonKey(name: 'emergency_contact_name') this.emergencyContactName, @JsonKey(name: 'emergency_contact_phone') this.emergencyContactPhone, this.notes, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _PatientModel.fromJson(Map<String, dynamic> json) => _$PatientModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'clinic_id') final  String clinicId;
@override@JsonKey(name: 'patient_number') final  String patientNumber;
@override@JsonKey(name: 'first_name') final  String firstName;
@override@JsonKey(name: 'last_name') final  String lastName;
@override@JsonKey(name: 'date_of_birth') final  DateTime dateOfBirth;
@override@_GenderConverter() final  Gender? gender;
@override@JsonKey(name: 'phone_number') final  String phoneNumber;
@override final  String? email;
@override@JsonKey(name: 'national_id') final  String? nationalId;
@override@JsonKey(name: 'blood_type')@_BloodTypeConverter() final  BloodType? bloodType;
@override final  String? address;
@override@JsonKey(name: 'emergency_contact_name') final  String? emergencyContactName;
@override@JsonKey(name: 'emergency_contact_phone') final  String? emergencyContactPhone;
@override final  String? notes;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of PatientModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientModelCopyWith<_PatientModel> get copyWith => __$PatientModelCopyWithImpl<_PatientModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PatientModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.patientNumber, patientNumber) || other.patientNumber == patientNumber)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.email, email) || other.email == email)&&(identical(other.nationalId, nationalId) || other.nationalId == nationalId)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.address, address) || other.address == address)&&(identical(other.emergencyContactName, emergencyContactName) || other.emergencyContactName == emergencyContactName)&&(identical(other.emergencyContactPhone, emergencyContactPhone) || other.emergencyContactPhone == emergencyContactPhone)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clinicId,patientNumber,firstName,lastName,dateOfBirth,gender,phoneNumber,email,nationalId,bloodType,address,emergencyContactName,emergencyContactPhone,notes,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'PatientModel(id: $id, clinicId: $clinicId, patientNumber: $patientNumber, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, gender: $gender, phoneNumber: $phoneNumber, email: $email, nationalId: $nationalId, bloodType: $bloodType, address: $address, emergencyContactName: $emergencyContactName, emergencyContactPhone: $emergencyContactPhone, notes: $notes, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PatientModelCopyWith<$Res> implements $PatientModelCopyWith<$Res> {
  factory _$PatientModelCopyWith(_PatientModel value, $Res Function(_PatientModel) _then) = __$PatientModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'clinic_id') String clinicId,@JsonKey(name: 'patient_number') String patientNumber,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName,@JsonKey(name: 'date_of_birth') DateTime dateOfBirth,@_GenderConverter() Gender? gender,@JsonKey(name: 'phone_number') String phoneNumber, String? email,@JsonKey(name: 'national_id') String? nationalId,@JsonKey(name: 'blood_type')@_BloodTypeConverter() BloodType? bloodType, String? address,@JsonKey(name: 'emergency_contact_name') String? emergencyContactName,@JsonKey(name: 'emergency_contact_phone') String? emergencyContactPhone, String? notes,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$PatientModelCopyWithImpl<$Res>
    implements _$PatientModelCopyWith<$Res> {
  __$PatientModelCopyWithImpl(this._self, this._then);

  final _PatientModel _self;
  final $Res Function(_PatientModel) _then;

/// Create a copy of PatientModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clinicId = null,Object? patientNumber = null,Object? firstName = null,Object? lastName = null,Object? dateOfBirth = null,Object? gender = freezed,Object? phoneNumber = null,Object? email = freezed,Object? nationalId = freezed,Object? bloodType = freezed,Object? address = freezed,Object? emergencyContactName = freezed,Object? emergencyContactPhone = freezed,Object? notes = freezed,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_PatientModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,patientNumber: null == patientNumber ? _self.patientNumber : patientNumber // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,nationalId: freezed == nationalId ? _self.nationalId : nationalId // ignore: cast_nullable_to_non_nullable
as String?,bloodType: freezed == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as BloodType?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,emergencyContactName: freezed == emergencyContactName ? _self.emergencyContactName : emergencyContactName // ignore: cast_nullable_to_non_nullable
as String?,emergencyContactPhone: freezed == emergencyContactPhone ? _self.emergencyContactPhone : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
