import 'package:flutter/material.dart';

import '../../../domain/entities/gender.dart';

class GenderSelector extends StatelessWidget {
  final Gender? value;
  final ValueChanged<Gender?> onChanged;

  const GenderSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gender', style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        SegmentedButton<Gender>(
          selected: value != null ? {value!} : {},
          emptySelectionAllowed: true,
          onSelectionChanged: (selection) =>
              onChanged(selection.isEmpty ? null : selection.first),
          segments: Gender.values
              .map(
                (g) => ButtonSegment<Gender>(
                  value: g,
                  label: Text(g.displayName),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
