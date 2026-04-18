import 'package:flutter/material.dart';

class ComingSoonTab extends StatelessWidget {
  const ComingSoonTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hourglass_empty, size: 48),
          SizedBox(height: 12),
          Text('Coming Soon'),
        ],
      ),
    );
  }
}
