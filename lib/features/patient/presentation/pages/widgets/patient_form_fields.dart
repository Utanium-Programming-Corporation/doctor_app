import 'package:flutter/material.dart';

import '../../../../../core/theme/components/app_form_field.dart';
import '../../../../../core/utils/app_validators.dart';

class PatientFormFields extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController dateOfBirthController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController nationalIdController;
  final TextEditingController addressController;
  final TextEditingController emergencyContactNameController;
  final TextEditingController emergencyContactPhoneController;
  final TextEditingController notesController;

  const PatientFormFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.dateOfBirthController,
    required this.phoneController,
    required this.emailController,
    required this.nationalIdController,
    required this.addressController,
    required this.emergencyContactNameController,
    required this.emergencyContactPhoneController,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppFormField.buildTextField(
          label: 'First Name',
          controller: firstNameController,
          validator: AppValidators.compose([
            AppValidators.required(),
            AppValidators.minLength(2),
            AppValidators.maxLength(50),
          ]),
        ),
        const SizedBox(height: 16),
        AppFormField.buildTextField(
          label: 'Last Name',
          controller: lastNameController,
          validator: AppValidators.compose([
            AppValidators.required(),
            AppValidators.minLength(2),
            AppValidators.maxLength(50),
          ]),
        ),
        const SizedBox(height: 16),
        AppFormField.buildTextField(
          label: 'Date of Birth (YYYY-MM-DD)',
          controller: dateOfBirthController,
          keyboardType: TextInputType.datetime,
          validator: AppValidators.compose([
            AppValidators.required(),
            AppValidators.dateNotFuture(),
          ]),
        ),
        const SizedBox(height: 16),
        AppFormField.buildTextField(
          label: 'Phone Number',
          controller: phoneController,
          keyboardType: TextInputType.phone,
          validator: AppValidators.compose([
            AppValidators.required(),
            AppValidators.phone(),
          ]),
        ),
        const SizedBox(height: 16),
        AppFormField.buildTextField(
          label: 'Email (optional)',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: AppValidators.email(),
        ),
        const SizedBox(height: 16),
        AppFormField.buildTextField(
          label: 'National ID (optional)',
          controller: nationalIdController,
        ),
        const SizedBox(height: 16),
        AppFormField.buildTextField(
          label: 'Address (optional)',
          controller: addressController,
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        AppFormField.buildTextField(
          label: 'Emergency Contact Name (optional)',
          controller: emergencyContactNameController,
        ),
        const SizedBox(height: 16),
        AppFormField.buildTextField(
          label: 'Emergency Contact Phone (optional)',
          controller: emergencyContactPhoneController,
          keyboardType: TextInputType.phone,
          validator: AppValidators.phone(),
        ),
        const SizedBox(height: 16),
        AppFormField.buildTextField(
          label: 'Notes (optional)',
          controller: notesController,
          maxLines: 4,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
