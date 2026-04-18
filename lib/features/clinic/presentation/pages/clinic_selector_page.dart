import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/clinic_cubit.dart';
import '../cubit/clinic_state.dart';
import 'widgets/clinic_card.dart';

class ClinicSelectorPage extends StatelessWidget {
  const ClinicSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Select a Clinic',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose which clinic you want to work in.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<ClinicCubit, ClinicState>(
                  builder: (context, state) {
                    if (state is ClinicLoaded) {
                      return ListView.separated(
                        itemCount: state.assignments.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final assignment = state.assignments[index];
                          return ClinicCard(
                            assignment: assignment,
                            onTap: () => context
                                .read<ClinicCubit>()
                                .selectClinic(assignment.clinicId),
                          );
                        },
                      );
                    }
                    return const Center(
                        child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
