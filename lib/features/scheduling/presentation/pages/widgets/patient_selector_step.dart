import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/components/app_form_field.dart';
import '../../cubit/book_appointment_cubit.dart';
import '../../cubit/book_appointment_state.dart';

class PatientSelectorStep extends StatefulWidget {
  final String clinicId;

  const PatientSelectorStep({super.key, required this.clinicId});

  @override
  State<PatientSelectorStep> createState() => _PatientSelectorStepState();
}

class _PatientSelectorStepState extends State<PatientSelectorStep> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
      builder: (context, state) {
        final inProgress =
            state is BookAppointmentInProgress ? state : null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Patient',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            AppFormField.buildTextFieldClearable(
              label: 'Search patient',
              controller: _searchController,
              onClear: () => context
                  .read<BookAppointmentCubit>()
                  .searchPatients(widget.clinicId, ''),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: inProgress?.isLoading == true
                  ? null
                  : () => context
                      .read<BookAppointmentCubit>()
                      .searchPatients(widget.clinicId, _searchController.text),
              child: inProgress?.isLoading == true
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Search'),
            ),
            if (inProgress?.error != null) ...[
              const SizedBox(height: 8),
              Text(inProgress!.error!,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 8),
            if (inProgress != null &&
                inProgress.patientSearchResults.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: inProgress.patientSearchResults.length,
                itemBuilder: (context, index) {
                  final patient = inProgress.patientSearchResults[index];
                  return ListTile(
                    title: Text(patient.fullName),
                    subtitle: Text(patient.phoneNumber),
                    onTap: () => context
                        .read<BookAppointmentCubit>()
                        .selectPatient(patient),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
