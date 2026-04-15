import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/components/app_form_field.dart';
import '../../../../core/utils/app_validators.dart';
import '../../domain/entities/clinic.dart';
import '../../domain/entities/clinic_type.dart';
import '../../domain/repositories/clinic_repository.dart';
import '../cubit/clinic_cubit.dart';
import '../cubit/clinic_state.dart';
import 'widgets/clinic_type_dropdown.dart';

class ClinicSettingsPage extends StatefulWidget {
  const ClinicSettingsPage({super.key});

  @override
  State<ClinicSettingsPage> createState() => _ClinicSettingsPageState();
}

class _ClinicSettingsPageState extends State<ClinicSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  ClinicType? _selectedType;
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _initFromClinic(Clinic clinic) {
    if (_initialized) return;
    _nameController.text = clinic.name;
    _phoneController.text = clinic.phone;
    _addressController.text = clinic.address;
    _selectedType = clinic.type;
    _initialized = true;
  }

  void _save(String clinicId) {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null) return;

    context.read<ClinicCubit>().updateClinic(
          UpdateClinicParams(
            clinicId: clinicId,
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            address: _addressController.text.trim(),
            type: _selectedType!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Clinic Settings')),
      body: BlocConsumer<ClinicCubit, ClinicState>(
        listener: (context, state) {
          if (state is ClinicError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is! ClinicLoaded || state.selectedClinic == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final clinic = state.selectedClinic!;
          _initFromClinic(clinic);

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppFormField.buildTextField(
                      label: 'Clinic Name',
                      controller: _nameController,
                      validator: AppValidators.compose([
                        AppValidators.required(
                            message: 'Clinic name is required'),
                        AppValidators.minLength(2),
                        AppValidators.maxLength(100),
                      ]),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    AppFormField.buildTextField(
                      label: 'Phone Number',
                      controller: _phoneController,
                      validator: AppValidators.phone(),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    AppFormField.buildTextField(
                      label: 'Address',
                      controller: _addressController,
                      validator: AppValidators.maxLength(200),
                      maxLines: 2,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    ClinicTypeDropdown(
                      value: _selectedType,
                      onChanged: (type) =>
                          setState(() => _selectedType = type),
                    ),
                    const SizedBox(height: 32),
                    FilledButton(
                      onPressed: () => _save(clinic.id),
                      child: const Text('Save Changes'),
                    ),
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      'Invite Code',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            clinic.inviteCode,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontFamily: 'monospace',
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          tooltip: 'Copy invite code',
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: clinic.inviteCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Invite code copied')),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => context
                          .read<ClinicCubit>()
                          .regenerateInviteCode(clinic.id),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Regenerate Invite Code'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
