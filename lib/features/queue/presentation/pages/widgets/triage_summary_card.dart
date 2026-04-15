import 'package:flutter/material.dart';

import '../../../domain/entities/triage_assessment.dart';

class TriageSummaryCard extends StatelessWidget {
  final TriageAssessment? assessment;

  const TriageSummaryCard({super.key, this.assessment});

  @override
  Widget build(BuildContext context) {
    if (assessment == null) {
      return const Text('No triage recorded',
          style: TextStyle(color: Colors.grey, fontSize: 12));
    }
    final a = assessment!;
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        if (a.bloodPressureSystolic != null && a.bloodPressureDiastolic != null)
          _vitals(
            Icons.monitor_heart,
            'BP ${a.bloodPressureSystolic}/${a.bloodPressureDiastolic}',
          ),
        if (a.heartRate != null)
          _vitals(Icons.favorite, 'HR ${a.heartRate} bpm'),
        if (a.temperature != null)
          _vitals(Icons.thermostat, 'Temp ${a.temperature}°C'),
        if (a.spo2 != null) _vitals(Icons.air, 'SpO₂ ${a.spo2}%'),
        if (a.weight != null) _vitals(Icons.monitor_weight, '${a.weight} kg'),
        if (a.chiefComplaint != null && a.chiefComplaint!.isNotEmpty)
          _vitals(Icons.note_alt, a.chiefComplaint!.length > 30
              ? '${a.chiefComplaint!.substring(0, 30)}…'
              : a.chiefComplaint!),
      ],
    );
  }

  Widget _vitals(IconData icon, String text) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.blueGrey),
          const SizedBox(width: 2),
          Text(text, style: const TextStyle(fontSize: 11)),
        ],
      );
}
