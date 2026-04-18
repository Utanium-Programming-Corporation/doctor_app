import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../clinic/presentation/cubit/clinic_cubit.dart';
import '../../../clinic/presentation/cubit/clinic_state.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/components/app_form_field.dart';
import '../../domain/usecases/triage_usecases.dart';
import '../cubit/triage_cubit.dart';
import '../cubit/triage_state.dart';

class TriageFormPage extends StatelessWidget {
  final String tokenId;

  const TriageFormPage({super.key, required this.tokenId});

  @override
  Widget build(BuildContext context) {
    final clinicState = context.read<ClinicCubit>().state;
    final clinicId =
        clinicState is ClinicLoaded ? (clinicState.selectedClinicId ?? '') : '';

    return BlocProvider(
      create: (_) => sl<TriageCubit>()..loadTriage(tokenId),
      child: _TriageFormView(
        tokenId: tokenId,
        clinicId: clinicId,
      ),
    );
  }
}

class _TriageFormView extends StatefulWidget {
  final String tokenId;
  final String clinicId;

  const _TriageFormView({required this.tokenId, required this.clinicId});

  @override
  State<_TriageFormView> createState() => _TriageFormViewState();
}

class _TriageFormViewState extends State<_TriageFormView> {
  final _formKey = GlobalKey<FormState>();
  final _bpSystolicCtrl = TextEditingController();
  final _bpDiastolicCtrl = TextEditingController();
  final _heartRateCtrl = TextEditingController();
  final _temperatureCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _spo2Ctrl = TextEditingController();
  final _chiefComplaintCtrl = TextEditingController();

  @override
  void dispose() {
    _bpSystolicCtrl.dispose();
    _bpDiastolicCtrl.dispose();
    _heartRateCtrl.dispose();
    _temperatureCtrl.dispose();
    _weightCtrl.dispose();
    _spo2Ctrl.dispose();
    _chiefComplaintCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TriageCubit, TriageState>(
      listener: (context, state) {
        if (state is TriageSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Triage saved')),
          );
          context.pop();
        }
        if (state is TriageError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is TriageLoaded && state.assessment != null) {
          final a = state.assessment!;
          _bpSystolicCtrl.text = a.bloodPressureSystolic?.toString() ?? '';
          _bpDiastolicCtrl.text = a.bloodPressureDiastolic?.toString() ?? '';
          _heartRateCtrl.text = a.heartRate?.toString() ?? '';
          _temperatureCtrl.text = a.temperature?.toString() ?? '';
          _weightCtrl.text = a.weight?.toString() ?? '';
          _spo2Ctrl.text = a.spo2?.toString() ?? '';
          _chiefComplaintCtrl.text = a.chiefComplaint ?? '';
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Triage Assessment')),
        body: BlocBuilder<TriageCubit, TriageState>(
          builder: (context, state) {
            if (state is TriageLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final isSubmitting = state is TriageLoading;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Vitals',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AppFormField.buildTextField(
                            label: 'BP Systolic (mmHg)',
                            controller: _bpSystolicCtrl,
                            keyboardType: TextInputType.number,
                            validator: _numRangeValidator(
                                60, 250, 'BP Systolic (60-250)'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppFormField.buildTextField(
                            label: 'BP Diastolic (mmHg)',
                            controller: _bpDiastolicCtrl,
                            keyboardType: TextInputType.number,
                            validator: _numRangeValidator(
                                30, 150, 'BP Diastolic (30-150)'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppFormField.buildTextField(
                      label: 'Heart Rate (bpm)',
                      controller: _heartRateCtrl,
                      keyboardType: TextInputType.number,
                      validator:
                          _numRangeValidator(30, 220, 'Heart Rate (30-220)'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AppFormField.buildTextField(
                            label: 'Temperature (°C)',
                            controller: _temperatureCtrl,
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true),
                            validator: _doubleRangeValidator(
                                34.0, 42.0, 'Temp (34-42°C)'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppFormField.buildTextField(
                            label: 'Weight (kg)',
                            controller: _weightCtrl,
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true),
                            validator: _doubleRangeValidator(
                                1.0, 300.0, 'Weight (1-300kg)'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppFormField.buildTextField(
                      label: 'SpO₂ (%)',
                      controller: _spo2Ctrl,
                      keyboardType: TextInputType.number,
                      validator: _numRangeValidator(50, 100, 'SpO₂ (50-100%)'),
                    ),
                    const Divider(height: 32),
                    Text('Complaint',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    AppFormField.buildTextField(
                      label: 'Chief Complaint',
                      controller: _chiefComplaintCtrl,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isSubmitting ? null : _submit,
                      child: isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save Triage'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    final recordedBy =
        Supabase.instance.client.auth.currentUser?.id ?? '';
    context.read<TriageCubit>().recordTriage(
          RecordTriageParams(
            queueTokenId: widget.tokenId,
            clinicId: widget.clinicId,
            recordedBy: recordedBy,
            bloodPressureSystolic:
                int.tryParse(_bpSystolicCtrl.text.trim()),
            bloodPressureDiastolic:
                int.tryParse(_bpDiastolicCtrl.text.trim()),
            heartRate: int.tryParse(_heartRateCtrl.text.trim()),
            temperature: double.tryParse(_temperatureCtrl.text.trim()),
            weight: double.tryParse(_weightCtrl.text.trim()),
            spo2: int.tryParse(_spo2Ctrl.text.trim()),
            chiefComplaint: _chiefComplaintCtrl.text.trim().isEmpty
                ? null
                : _chiefComplaintCtrl.text.trim(),
          ),
        );
  }

  String? Function(String?) _numRangeValidator(int min, int max, String label) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      final n = int.tryParse(value.trim());
      if (n == null) return 'Enter a valid number';
      if (n < min || n > max) return '$label out of range';
      return null;
    };
  }

  String? Function(String?) _doubleRangeValidator(
      double min, double max, String label) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      final n = double.tryParse(value.trim());
      if (n == null) return 'Enter a valid number';
      if (n < min || n > max) return '$label out of range';
      return null;
    };
  }
}
