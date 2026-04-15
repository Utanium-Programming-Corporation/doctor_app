import 'package:flutter/material.dart';

import '../../../domain/entities/provider_availability.dart';
import '../../../domain/repositories/availability_params.dart';

class AvailabilityDayCard extends StatelessWidget {
  final int dayOfWeek; // 1=Mon … 7=Sun
  final List<ProviderAvailability> entries;
  final void Function(AvailabilityEntry) onAddEntry;
  final void Function(String id) onRemoveEntry;
  final void Function(String id, bool isActive) onToggleEntry;

  const AvailabilityDayCard({
    super.key,
    required this.dayOfWeek,
    required this.entries,
    required this.onAddEntry,
    required this.onRemoveEntry,
    required this.onToggleEntry,
  });

  static const _dayNames = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Text(_dayNames[dayOfWeek],
            style: Theme.of(context).textTheme.titleMedium),
        subtitle: entries.isEmpty
            ? const Text('No availability set')
            : Text('${entries.length} window(s)'),
        children: [
          ...entries.map(
            (e) => ListTile(
              dense: true,
              title: Text('${e.startTime} – ${e.endTime}'),
              leading: Switch(
                value: e.isActive,
                onChanged: (v) => onToggleEntry(e.id, e.isActive),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: Theme.of(context).colorScheme.error,
                onPressed: () => onRemoveEntry(e.id),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: OutlinedButton.icon(
              onPressed: () => _showAddEntryDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add window'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddEntryDialog(BuildContext context) async {
    TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 17, minute: 0);

    final picked = await showDialog<({TimeOfDay start, TimeOfDay end})>(
      context: context,
      builder: (ctx) => _TimeRangeDialog(
        initialStart: startTime,
        initialEnd: endTime,
      ),
    );
    if (picked != null) {
      onAddEntry(AvailabilityEntry(
        dayOfWeek: dayOfWeek,
        startTime: _fmt(picked.start),
        endTime: _fmt(picked.end),
      ));
    }
  }

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

class _TimeRangeDialog extends StatefulWidget {
  final TimeOfDay initialStart;
  final TimeOfDay initialEnd;

  const _TimeRangeDialog({
    required this.initialStart,
    required this.initialEnd,
  });

  @override
  State<_TimeRangeDialog> createState() => _TimeRangeDialogState();
}

class _TimeRangeDialogState extends State<_TimeRangeDialog> {
  late TimeOfDay _start;
  late TimeOfDay _end;

  @override
  void initState() {
    super.initState();
    _start = widget.initialStart;
    _end = widget.initialEnd;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add availability window'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Start'),
            trailing: Text(_start.format(context)),
            onTap: () async {
              final t = await showTimePicker(
                  context: context, initialTime: _start);
              if (t != null) setState(() => _start = t);
            },
          ),
          ListTile(
            title: const Text('End'),
            trailing: Text(_end.format(context)),
            onTap: () async {
              final t = await showTimePicker(
                  context: context, initialTime: _end);
              if (t != null) setState(() => _end = t);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop((start: _start, end: _end)),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
