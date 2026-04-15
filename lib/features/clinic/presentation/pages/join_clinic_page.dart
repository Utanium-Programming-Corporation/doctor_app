import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/components/app_form_field.dart';
import '../../../../core/utils/app_validators.dart';
import '../../domain/repositories/clinic_repository.dart';
import '../cubit/clinic_cubit.dart';
import '../cubit/clinic_state.dart';

class JoinClinicPage extends StatefulWidget {
  const JoinClinicPage({super.key});

  @override
  State<JoinClinicPage> createState() => _JoinClinicPageState();
}

class _JoinClinicPageState extends State<JoinClinicPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _looked = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _lookup() {
    if (!_formKey.currentState!.validate()) return;
    context
        .read<ClinicCubit>()
        .lookupClinicByCode(_codeController.text.trim().toUpperCase());
  }

  void _confirm() {
    context.read<ClinicCubit>().joinClinic(
          JoinClinicByCodeParams(
            inviteCode: _codeController.text.trim().toUpperCase(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Join Clinic')),
      body: BlocConsumer<ClinicCubit, ClinicState>(
        listener: (context, state) {
          if (state is ClinicError) {
            setState(() => _looked = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is ClinicLoaded && state.selectedClinic != null && !_looked) {
            setState(() => _looked = true);
          }
        },
        builder: (context, state) {
          final isLoading = state is ClinicLoading;
          final clinic =
              state is ClinicLoaded ? state.selectedClinic : null;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppFormField.buildTextField(
                      label: 'Invite Code',
                      controller: _codeController,
                      validator: AppValidators.compose([
                        AppValidators.required(
                            message: 'Invite code is required'),
                        AppValidators.minLength(8,
                            message: 'Invite code must be 8 characters'),
                        AppValidators.maxLength(8,
                            message: 'Invite code must be 8 characters'),
                      ]),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 24),
                    if (!_looked) ...[
                      FilledButton(
                        onPressed: isLoading ? null : _lookup,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              )
                            : const Text('Look Up Clinic'),
                      ),
                    ],
                    if (_looked && clinic != null) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Clinic Found',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                clinic.name,
                                style: theme.textTheme.headlineSmall,
                              ),
                              if (clinic.address.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  clinic.address,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: isLoading ? null : _confirm,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              )
                            : const Text('Join This Clinic'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () => setState(() => _looked = false),
                        child: const Text('Try Another Code'),
                      ),
                    ],
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
