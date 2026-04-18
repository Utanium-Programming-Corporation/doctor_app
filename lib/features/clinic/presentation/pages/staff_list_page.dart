import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/clinic_repository.dart';
import '../cubit/clinic_cubit.dart';
import '../cubit/clinic_state.dart';
import 'widgets/role_selector_dialog.dart';
import 'widgets/staff_member_tile.dart';

class StaffListPage extends StatefulWidget {
  const StaffListPage({super.key});

  @override
  State<StaffListPage> createState() => _StaffListPageState();
}

class _StaffListPageState extends State<StaffListPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<ClinicCubit>();
    final state = cubit.state;
    if (state is ClinicLoaded && state.selectedClinicId != null) {
      cubit.loadStaff(state.selectedClinicId!);
    }
  }

  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff')),
      body: BlocConsumer<ClinicCubit, ClinicState>(
        listener: (context, state) {
          if (state is ClinicError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is! ClinicLoaded || state.staff == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final staff = state.staff!;
          if (staff.isEmpty) {
            return const Center(child: Text('No staff members found.'));
          }

          return ListView.separated(
            itemCount: staff.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final member = staff[index];
              final isMe = member.userId == _currentUserId;

              return StaffMemberTile(
                assignment: member,
                isCurrentUser: isMe,
                onChangeRole: isMe
                    ? null
                    : () async {
                        final newRole = await RoleSelectorDialog.show(
                          context,
                          currentRole: member.role,
                        );
                        if (newRole != null &&
                            newRole != member.role &&
                            context.mounted) {
                          context.read<ClinicCubit>().updateStaffRole(
                                UpdateStaffRoleParams(
                                  assignmentId: member.id,
                                  newRole: newRole,
                                ),
                              );
                        }
                      },
                onDeactivate: isMe
                    ? null
                    : () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Deactivate Staff'),
                            content: Text(
                              'Remove ${member.userName ?? 'this member'} from the clinic?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Deactivate'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true && context.mounted) {
                          context
                              .read<ClinicCubit>()
                              .deactivateStaff(member.id);
                        }
                      },
              );
            },
          );
        },
      ),
    );
  }
}
