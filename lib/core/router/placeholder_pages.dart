import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';

class AccessDeniedPage extends StatelessWidget {
  const AccessDeniedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Access Denied')));
  }
}

class HomePlaceholderPage extends StatelessWidget {
  const HomePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Home — Placeholder')));
  }
}

class AppointmentsPlaceholderPage extends StatelessWidget {
  const AppointmentsPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(child: Text('Appointments — Placeholder')));
  }
}

class AppointmentDetailPlaceholderPage extends StatelessWidget {
  const AppointmentDetailPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(child: Text('Appointment Detail — Placeholder')));
  }
}

class SettingsPlaceholderPage extends StatelessWidget {
  const SettingsPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () => context.read<AuthCubit>().signOut(),
          ),
        ],
      ),
    );
  }
}

