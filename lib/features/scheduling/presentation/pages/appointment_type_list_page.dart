import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/route_names.dart';
import '../cubit/appointment_type_cubit.dart';
import '../cubit/appointment_type_state.dart';

class AppointmentTypeListPage extends StatelessWidget {
  final String clinicId;

  const AppointmentTypeListPage({super.key, required this.clinicId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<AppointmentTypeCubit>()..loadTypes(clinicId),
      child: _AppointmentTypeListView(clinicId: clinicId),
    );
  }
}

class _AppointmentTypeListView extends StatelessWidget {
  final String clinicId;

  const _AppointmentTypeListView({required this.clinicId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Types'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                context.pushNamed(RouteNames.appointmentTypeNew,
                    queryParameters: {'clinicId': clinicId}),
          ),
        ],
      ),
      body: BlocBuilder<AppointmentTypeCubit, AppointmentTypeState>(
        builder: (context, state) {
          return switch (state) {
            AppointmentTypeInitial() ||
            AppointmentTypeLoading() =>
              const Center(child: CircularProgressIndicator()),
            AppointmentTypeError(:final message) =>
              Center(child: Text(message)),
            AppointmentTypeLoaded(:final types) => types.isEmpty
                ? const Center(child: Text('No appointment types yet.'))
                : ListView.separated(
                    itemCount: types.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final type = types[index];
                      final color = _hexColor(type.colorHex);
                      return ListTile(
                        leading: CircleAvatar(backgroundColor: color, radius: 10),
                        title: Text(type.name),
                        subtitle: Text('${type.durationMinutes} min'
                            '${type.description != null ? ' · ${type.description}' : ''}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: type.isActive,
                              onChanged: (_) => context
                                  .read<AppointmentTypeCubit>()
                                  .toggleActive(type.id, type.isActive),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => context.pushNamed(
                                RouteNames.appointmentTypeEdit,
                                pathParameters: {'id': type.id},
                                queryParameters: {'clinicId': clinicId},
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          };
        },
      ),
    );
  }

  Color _hexColor(String hex) {
    final clean = hex.replaceFirst('#', '');
    final val = int.tryParse(
        clean.length == 6 ? 'FF$clean' : clean,
        radix: 16);
    return val != null ? Color(val) : Colors.blue;
  }
}
