import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';

class ClinicOrJoinPage extends StatelessWidget {
  const ClinicOrJoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.local_hospital_outlined,
                size: 72,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Set Up Your Clinic',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Create a new clinic or join an existing one with an invite code.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              FilledButton.icon(
                onPressed: () => context.pushNamed(RouteNames.createClinic),
                icon: const Icon(Icons.add_business),
                label: const Text('Create a New Clinic'),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => context.pushNamed(RouteNames.joinClinic),
                icon: const Icon(Icons.group_add),
                label: const Text('Join with Invite Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
