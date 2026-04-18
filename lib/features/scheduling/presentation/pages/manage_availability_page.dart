import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/repositories/availability_params.dart';
import '../cubit/availability_cubit.dart';
import '../cubit/availability_state.dart';
import 'widgets/availability_day_card.dart';
import 'widgets/blocked_date_list.dart';

class ManageAvailabilityPage extends StatelessWidget {
  final String clinicId;
  final String providerId;

  const ManageAvailabilityPage({
    super.key,
    required this.clinicId,
    required this.providerId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AvailabilityCubit>()
        ..loadAvailability(clinicId: clinicId, providerId: providerId),
      child: _ManageAvailabilityView(clinicId: clinicId),
    );
  }
}

class _ManageAvailabilityView extends StatefulWidget {
  final String clinicId;

  const _ManageAvailabilityView({required this.clinicId});

  @override
  State<_ManageAvailabilityView> createState() =>
      _ManageAvailabilityViewState();
}

class _ManageAvailabilityViewState extends State<_ManageAvailabilityView> {
  /// Pending edits — starts as a copy of loaded entries, modified locally
  final _pendingEntries = <AvailabilityEntry>[];
  bool _pendingLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Availability')),
      body: BlocConsumer<AvailabilityCubit, AvailabilityState>(
        listener: (context, state) {
          if (state is AvailabilityLoaded && !state.isSaving && _pendingLoaded) {
            _pendingEntries.clear();
            _pendingLoaded = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Availability saved.')),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            AvailabilityInitial() ||
            AvailabilityLoading() =>
              const Center(child: CircularProgressIndicator()),
            AvailabilityError(:final message) =>
              Center(child: Text(message)),
            AvailabilityLoaded(
              :final weeklyEntries,
              :final blockedDates,
              :final isSaving,
            ) =>
              ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Text(
                      'Weekly Schedule',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  for (int day = 1; day <= 7; day++)
                    AvailabilityDayCard(
                      dayOfWeek: day,
                      entries: weeklyEntries[day] ?? [],
                      onAddEntry: (entry) {
                        _pendingEntries.add(entry);
                        setState(() {});
                      },
                      onRemoveEntry: (id) {
                        final allEntries = <AvailabilityEntry>[];
                        for (int d = 1; d <= 7; d++) {
                          for (final e in weeklyEntries[d] ?? []) {
                            if (e.id != id) {
                              allEntries.add(AvailabilityEntry(
                                dayOfWeek: e.dayOfWeek,
                                startTime: e.startTime,
                                endTime: e.endTime,
                                locationId: e.locationId,
                                isActive: e.isActive,
                              ));
                            }
                          }
                        }
                        context.read<AvailabilityCubit>().saveAll(
                          clinicId: widget.clinicId,
                          entries: allEntries,
                        );
                      },
                      onToggleEntry: (id, isActive) {
                        final allEntries = <AvailabilityEntry>[];
                        for (int d = 1; d <= 7; d++) {
                          for (final e in weeklyEntries[d] ?? []) {
                            allEntries.add(AvailabilityEntry(
                              dayOfWeek: e.dayOfWeek,
                              startTime: e.startTime,
                              endTime: e.endTime,
                              locationId: e.locationId,
                              isActive: e.id == id ? !isActive : e.isActive,
                            ));
                          }
                        }
                        context.read<AvailabilityCubit>().saveAll(
                          clinicId: widget.clinicId,
                          entries: allEntries,
                        );
                      },
                    ),
                  const Divider(height: 32),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Blocked Dates',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  BlockedDateList(
                    blockedDates: blockedDates,
                    onRemove: (id) =>
                        context.read<AvailabilityCubit>().removeBlockedDate(id),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: OutlinedButton.icon(
                      onPressed: isSaving
                          ? null
                          : () => _addBlockedDate(context),
                      icon: const Icon(Icons.block),
                      label: const Text('Block a Date'),
                    ),
                  ),
                  if (_pendingEntries.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: FilledButton(
                        onPressed: isSaving
                            ? null
                            : () {
                                _pendingLoaded = true;
                                final allEntries = <AvailabilityEntry>[];
                                for (int d = 1; d <= 7; d++) {
                                  for (final e in weeklyEntries[d] ?? []) {
                                    allEntries.add(AvailabilityEntry(
                                      dayOfWeek: e.dayOfWeek,
                                      startTime: e.startTime,
                                      endTime: e.endTime,
                                      locationId: e.locationId,
                                      isActive: e.isActive,
                                    ));
                                  }
                                }
                                allEntries.addAll(_pendingEntries);
                                context.read<AvailabilityCubit>().saveAll(
                                  clinicId: widget.clinicId,
                                  entries: allEntries,
                                );
                              },
                        child: const Text('Save Changes'),
                      ),
                    ),
                ],
              ),
          };
        },
      ),
    );
  }

  Future<void> _addBlockedDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) return;
    final reasonCtrl = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reason (optional)'),
        content: TextField(controller: reasonCtrl),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(ctx).pop(reasonCtrl.text.trim()),
            child: const Text('Block'),
          ),
        ],
      ),
    );
    reasonCtrl.dispose();
    if (reason != null && context.mounted) {
      await context.read<AvailabilityCubit>().addBlockedDate(
        clinicId: widget.clinicId,
        date: date,
        reason: reason.isEmpty ? null : reason,
      );
    }
  }
}
