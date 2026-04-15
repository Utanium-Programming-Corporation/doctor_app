import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/appointment_type.dart';
import '../../domain/repositories/availability_params.dart';
import '../cubit/appointment_type_cubit.dart';
import '../cubit/appointment_type_state.dart';

class AppointmentTypeFormPage extends StatefulWidget {
  final String clinicId;
  final AppointmentType? existing;

  const AppointmentTypeFormPage({
    super.key,
    required this.clinicId,
    this.existing,
  });

  @override
  State<AppointmentTypeFormPage> createState() =>
      _AppointmentTypeFormPageState();
}

class _AppointmentTypeFormPageState extends State<AppointmentTypeFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descriptionCtrl;
  late int _durationMinutes;
  late String _colorHex;
  late bool _isActive;

  static const _durations = [15, 30, 45, 60, 90, 120];
  static const _colors = [
    '3B82F6', 'EF4444', '10B981', 'F59E0B', '8B5CF6', 'EC4899', '14B8A6',
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _descriptionCtrl = TextEditingController(text: e?.description ?? '');
    _durationMinutes = e?.durationMinutes ?? 30;
    _colorHex = e?.colorHex.replaceFirst('#', '') ?? _colors[0];
    _isActive = e?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    return BlocProvider(
      create: (_) => sl<AppointmentTypeCubit>(),
      child: BlocConsumer<AppointmentTypeCubit, AppointmentTypeState>(
        listener: (context, state) {
          if (state is AppointmentTypeLoaded && !state.isSaving) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final isSaving =
              state is AppointmentTypeLoaded && state.isSaving;
          return Scaffold(
            appBar: AppBar(
              title: Text(isEditing ? 'Edit Type' : 'New Appointment Type'),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Description'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: _durationMinutes,
                    decoration:
                        const InputDecoration(labelText: 'Duration (min)'),
                    items: _durations
                        .map((d) => DropdownMenuItem(
                              value: d,
                              child: Text('$d min'),
                            ))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _durationMinutes = v ?? 30),
                  ),
                  const SizedBox(height: 16),
                  const Text('Color'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _colors.map((hex) {
                      final selected = _colorHex == hex;
                      return GestureDetector(
                        onTap: () => setState(() => _colorHex = hex),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: _hexColor(hex),
                          child: selected
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 16)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Active'),
                    value: _isActive,
                    onChanged: (v) => setState(() => _isActive = v),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: isSaving ? null : _submit,
                    child: isSaving
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isEditing ? 'Update' : 'Create'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<AppointmentTypeCubit>();
    if (widget.existing != null) {
      cubit.updateType(UpdateAppointmentTypeParams(
        id: widget.existing!.id,
        name: _nameCtrl.text.trim(),
        durationMinutes: _durationMinutes,
        colorHex: '#$_colorHex',
        description: _descriptionCtrl.text.trim().isEmpty
            ? null
            : _descriptionCtrl.text.trim(),
        isActive: _isActive,
      ));
    } else {
      cubit.createType(CreateAppointmentTypeParams(
        clinicId: widget.clinicId,
        name: _nameCtrl.text.trim(),
        durationMinutes: _durationMinutes,
        colorHex: '#$_colorHex',
        description: _descriptionCtrl.text.trim().isEmpty
            ? null
            : _descriptionCtrl.text.trim(),
        isActive: _isActive,
      ));
    }
  }

  Color _hexColor(String hex) {
    final val = int.tryParse('FF$hex', radix: 16);
    return val != null ? Color(val) : Colors.blue;
  }
}
