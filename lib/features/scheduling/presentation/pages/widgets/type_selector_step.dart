import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/appointment_type.dart';
import '../../cubit/book_appointment_cubit.dart';
import '../../cubit/book_appointment_state.dart';

class TypeSelectorStep extends StatelessWidget {
  const TypeSelectorStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
      builder: (context, state) {
        final inProgress =
            state is BookAppointmentInProgress ? state : null;
        final types =
            inProgress?.appointmentTypes ?? <AppointmentType>[];

        if (inProgress?.isLoading == true) {
          return const Center(child: CircularProgressIndicator());
        }

        if (types.isEmpty) {
          return const Center(
            child: Text(
                'No appointment types available. Please create one first.'),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Appointment Type',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: types.length,
              itemBuilder: (context, index) {
                final type = types[index];
                final colorHex = type.colorHex.replaceFirst('#', '');
                final color = Color(
                  int.parse('FF$colorHex', radix: 16),
                );
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: color, radius: 12),
                    title: Text(type.name),
                    subtitle: Text('${type.durationMinutes} min'
                        '${type.description != null ? ' \u2022 ${type.description}' : ''}'),
                    onTap: () => context
                        .read<BookAppointmentCubit>()
                        .selectAppointmentType(type),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
