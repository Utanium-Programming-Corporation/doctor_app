import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/components/app_form_field.dart';
import '../../../../core/utils/app_validators.dart';
import '../../../clinic/domain/entities/clinic_type.dart';
import '../../../clinic/domain/repositories/clinic_repository.dart';
import '../cubit/clinic_cubit.dart';
import '../cubit/clinic_state.dart';
import 'widgets/clinic_type_dropdown.dart';

class CreateClinicPage extends StatefulWidget {
  const CreateClinicPage({super.key});

  @override
  State<CreateClinicPage> createState() => _CreateClinicPageState();
}

class _CreateClinicPageState extends State<CreateClinicPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  ClinicType? _selectedType;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null) return;

    context.read<ClinicCubit>().createClinic(
          CreateClinicParams(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            address: _addressController.text.trim(),
            type: _selectedType!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Clinic')),
      body: BlocListener<ClinicCubit, ClinicState>(
        listener: (context, state) {
          if (state is ClinicError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SafeArea(
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
                      AppValidators.required(message: 'Clinic name is required'),
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
                    onChanged: (type) => setState(() => _selectedType = type),
                    validator: (value) =>
                        value == null ? 'Please select a clinic type' : null,
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<ClinicCubit, ClinicState>(
                    builder: (context, state) {
                      final isLoading = state is ClinicLoading;
                      return FilledButton(
                        onPressed: isLoading ? null : _submit,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Create Clinic'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
