import 'package:flutter/material.dart';

import '../../../domain/entities/queue_token_status.dart';

class QueueStatusChip extends StatelessWidget {
  final QueueTokenStatus status;

  const QueueStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        status.displayName,
        style: TextStyle(color: _foreground, fontSize: 12),
      ),
      backgroundColor: _background,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Color get _background => switch (status) {
        QueueTokenStatus.waiting => Colors.blue.shade100,
        QueueTokenStatus.called => Colors.orange.shade200,
        QueueTokenStatus.inProgress => Colors.green.shade200,
        QueueTokenStatus.completed => Colors.grey.shade300,
        QueueTokenStatus.noShow => Colors.red.shade200,
        QueueTokenStatus.skipped => Colors.amber.shade200,
      };

  Color get _foreground => switch (status) {
        QueueTokenStatus.waiting => Colors.blue.shade800,
        QueueTokenStatus.called => Colors.orange.shade800,
        QueueTokenStatus.inProgress => Colors.green.shade800,
        QueueTokenStatus.completed => Colors.grey.shade700,
        QueueTokenStatus.noShow => Colors.red.shade800,
        QueueTokenStatus.skipped => Colors.amber.shade800,
      };
}
