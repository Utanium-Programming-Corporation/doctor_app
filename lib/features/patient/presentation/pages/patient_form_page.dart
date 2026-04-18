import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/route_names.dart';
import '../../../clinic/presentation/cubit/clinic_cubit.dart';
import '../../../clinic/presentation/cubit/clinic_state.dart';
import '../../domain/entities/blood_type.dart';
import '../../domain/entities/gender.dart';
import '../../domain/entities/patient.dart';
import '../../domain/repositories/patient_repository.dart';
import '../cubit/patient_detail_cubit.dart';
import '../cubit/patient_detail_state.dart';
import 'widgets/blood_type_dropdown.dart';
import 'widgets/gender_selector.dart';
import 'widgets/patient_form_fields.dart';

class PatientFormPage extends StatelessWidget {
  final String? patientId;

  const PatientFormPage({super.key, this.patientId});

  bool get isEditMode => patientId != null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<PatientDetailCubit>();
        if (isEditMode) cubit.loadPatient(patientId!);
        return cubit;
      },
      child: _PatientFormView(patientId: patientId),
    );
  }
}

class _PatientFormView extends StatefulWidget {
  final String? patientId;

  const _PatientFormView({this.patientId});

  bool get isEditMode => patientId != null;

  @override
  State<_PatientFormView> createState() => _PatientFormViewState();
}

class _PatientFormViewState extends State<_PatientFormView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _nationalIdCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _emergencyNameCtrl = TextEditingController();
  final _emergencyPhoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  Gender? _gender;
  BloodType? _bloodType;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _dobCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _nationalIdCtrl.dispose();
    _addressCtrl.dispose();
    _emergencyNameCtrl.dispose();
    _emergencyPhoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _prefillFrom(Patient patient) {
    _firstNameCtrl.text = patient.firstName;
    _lastNameCtrl.text = patient.lastName;
    _dobCtrl.text = patient.dateOfBirth.toIso8601String().split('T')[0];
    _phoneCtrl.text = patient.phoneNumber;
    _emailCtrl.text = patient.email ?? '';
    _nationalIdCtrl.text = patient.nationalId ?? '';
    _addressCtrl.text = patient.address ?? '';
    _emergencyNameCtrl.text = patient.emergencyContactName ?? '';
    _emergencyPhoneCtrl.text = patient.emergencyContactPhone ?? '';
    _notesCtrl.text = patient.notes ?? '';
    setState(() {
      _gender = patient.gender;
      _bloodType = patient.bloodType;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final clinicState = context.read<ClinicCubit>().state;
    if (clinicState is! ClinicLoaded || clinicState.selectedClinicId == null) {
      return;
    }
    final dob = DateTime.tryParse(_dobCtrl.text);
    if (dob == null) return;

    if (widget.isEditMode) {
      context.read<PatientDetailCubit>().updatePatient(
            UpdatePatientParams(
              id: widget.patientId!,
              firstName: _firstNameCtrl.text.trim(),
              lastName: _lastNameCtrl.text.trim(),
              dateOfBirth: dob,
              phoneNumber: _phoneCtrl.text.trim(),
              gender: _gender,
              email: _emailCtrl.text.trim().isEmpty
                  ? null
                  : _emailCtrl.text.trim(),
              nationalId: _nationalIdCtrl.text.trim().isEmpty
                  ? null
                  : _nationalIdCtrl.text.trim(),
              bloodType: _bloodType,
              address: _addressCtrl.text.trim().isEmpty
                  ? null
                  : _addressCtrl.text.trim(),
              emergencyContactName:
                  _emergencyNameCtrl.text.trim().isEmpty
                      ? null
                      : _emergencyNameCtrl.text.trim(),
              emergencyContactPhone:
                  _emergencyPhoneCtrl.text.trim().isEmpty
                      ? null
                      : _emergencyPhoneCtrl.text.trim(),
              notes: _notesCtrl.text.trim().isEmpty
                  ? null
                  : _notesCtrl.text.trim(),
            ),
          );
    } else {
      context.read<PatientDetailCubit>().createPatient(
            CreatePatientParams(
              clinicId: clinicState.selectedClinicId!,
              firstName: _firstNameCtrl.text.trim(),
              lastName: _lastNameCtrl.text.trim(),
              dateOfBirth: dob,
              phoneNumber: _phoneCtrl.text.trim(),
              gender: _gender,
              email: _emailCtrl.text.trim().isEmpty
                  ? null
                  : _emailCtrl.text.trim(),
              nationalId: _nationalIdCtrl.text.trim().isEmpty
                  ? null
                  : _nationalIdCtrl.text.trim(),
              bloodType: _bloodType,
              address: _addressCtrl.text.trim().isEmpty
                  ? null
                  : _addressCtrl.text.trim(),
              emergencyContactName:
                  _emergencyNameCtrl.text.trim().isEmpty
                      ? null
                      : _emergencyNameCtrl.text.trim(),
              emergencyContactPhone:
                  _emergencyPhoneCtrl.text.trim().isEmpty
                      ? null
                      : _emergencyPhoneCtrl.text.trim(),
              notes: _notesCtrl.text.trim().isEmpty
                  ? null
                  : _notesCtrl.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Edit Patient' : 'New Patient'),
      ),
      body: BlocConsumer<PatientDetailCubit, PatientDetailState>(
        listener: (context, state) {
          if (state is PatientDetailSaved) {
            context.goNamed(
              RouteNames.patientDetail,
              pathParameters: {'id': state.patient.id},
            );
          }
          if (state is PatientDetailLoaded && widget.isEditMode) {
            _prefillFrom(state.patient);
          }
        },
        builder: (context, state) {
          if (state is PatientDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PatientFormFields(
                  firstNameController: _firstNameCtrl,
                  lastNameController: _lastNameCtrl,
                  dateOfBirthController: _dobCtrl,
                  phoneController: _phoneCtrl,
                  emailController: _emailCtrl,
                  nationalIdController: _nationalIdCtrl,
                  addressController: _addressCtrl,
                  emergencyContactNameController: _emergencyNameCtrl,
                  emergencyContactPhoneController: _emergencyPhoneCtrl,
                  notesController: _notesCtrl,
                ),
                const SizedBox(height: 16),
                GenderSelector(
                  value: _gender,
                  onChanged: (g) => setState(() => _gender = g),
                ),
                const SizedBox(height: 16),
                BloodTypeDropdown(
                  value: _bloodType,
                  onChanged: (bt) => setState(() => _bloodType = bt),
                ),
                const SizedBox(height: 32),
                if (state is PatientDetailError)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      state.message,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                FilledButton(
                  onPressed: _submit,
                  child: const Text('Save'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
