import 'package:flutter/material.dart';

import '../../../domain/entities/queue_priority.dart';
import '../../../domain/entities/queue_token.dart';
import '../../../domain/entities/triage_assessment.dart';
import 'queue_status_chip.dart';
import 'triage_summary_card.dart';

class QueueTokenTile extends StatelessWidget {
  final QueueToken token;
  final TriageAssessment? triage;
  final VoidCallback? onTap;

  const QueueTokenTile({
    super.key,
    required this.token,
    this.triage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    token.formattedToken,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (token.priority == QueuePriority.urgent) ...[
                    const SizedBox(width: 8),
                    const Chip(
                      label: Text('URGENT',
                          style: TextStyle(fontSize: 10, color: Colors.white)),
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                  const Spacer(),
                  QueueStatusChip(status: token.status),
                ],
              ),
              if (token.patientName != null) ...[
                const SizedBox(height: 4),
                Text(token.patientName!,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
              if (token.providerName != null)
                Text('Dr. ${token.providerName!}',
                    style: Theme.of(context).textTheme.bodySmall),
              if (triage != null) ...[
                const SizedBox(height: 8),
                TriageSummaryCard(assessment: triage),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
