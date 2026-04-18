import 'package:flutter/material.dart';

import '../../../domain/entities/blocked_date.dart';

class BlockedDateList extends StatelessWidget {
  final List<BlockedDate> blockedDates;
  final void Function(String id) onRemove;

  const BlockedDateList({
    super.key,
    required this.blockedDates,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (blockedDates.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text('No blocked dates.',
            style: TextStyle(color: Colors.grey)),
      );
    }
    return Column(
      children: blockedDates.map((b) {
        final date = b.blockedDate;
        return ListTile(
          leading: const Icon(Icons.event_busy),
          title: Text(
              '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'),
          subtitle: b.reason != null ? Text(b.reason!) : null,
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Remove block',
            onPressed: () => onRemove(b.id),
          ),
        );
      }).toList(),
    );
  }
}
